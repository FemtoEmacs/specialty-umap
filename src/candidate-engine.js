/* Pure inference: same equations and serialized parameters as Common Lisp. */
globalThis.CandidateMap = (() => {
  const dot = (a, b) => a.reduce((s, v, i) => s + v * b[i], 0);
  const add = (a, b) => a.map((v, i) => v + b[i]);
  const mv = (m, x, b) => m.map((r, i) => dot(r, x) + (b?.[i] || 0));
  const norm = (x) => x.map((v) => v / Math.sqrt(dot(x, x) / x.length + 1e-6));
  const distance = (a, b) => a.reduce((s, v, i) => s + (v - b[i]) ** 2, 0);
  const normalize = (x, s) => x.map((v, i) => (v - s.means[i]) / s.scales[i]);
  const quantile = (xs, p) => {
    const a = [...xs].sort((a, b) => a - b),
      t = (a.length - 1) * p,
      i = Math.floor(t);
    return a[i] + (a[Math.min(i + 1, a.length - 1)] - a[i]) * (t - i);
  };
  function forward(model, input) {
    const [embedding, sw, sb, q, k, v, o, w1, b1, w2, b2, out, bias] =
      model.parameters;
    if (
      input.length !== model.feature_count ||
      input.some((x) => !Number.isFinite(x))
    )
      throw Error("Invalid model input");
    const tokens = input.map((x, i) =>
      embedding[i].map((e, j) => e + sw[j] * x + sb[j]),
    );
    const queries = tokens.map((t) => mv(q, t)),
      keys = tokens.map((t) => mv(k, t)),
      values = tokens.map((t) => mv(v, t));
    const encoded = tokens.map((t, i) => {
      const scores = keys.map(
        (key) => dot(queries[i], key) / Math.sqrt(model.d_model),
      );
      const maximum = Math.max(...scores),
        exps = scores.map((s) => Math.exp(s - maximum)),
        total = exps.reduce((a, b) => a + b, 0);
      const mixed = t.map((_, j) =>
        values.reduce((s, value, h) => s + (exps[h] / total) * value[j], 0),
      );
      const state = norm(add(t, mv(o, mixed)));
      return norm(add(state, mv(w2, mv(w1, state, b1).map(Math.tanh), b2)));
    });
    return mv(
      out,
      encoded[0].map(
        (_, j) => encoded.reduce((s, t) => s + t[j], 0) / encoded.length,
      ),
      bias,
    );
  }
  function predict(artifact, input) {
    const result = forward(
      artifact.model,
      normalize(input, artifact.preprocessing),
    );
    return result.map(
      (v, i) =>
        v * artifact.target_preprocessing.scales[i] +
        artifact.target_preprocessing.means[i],
    );
  }
  function halton(n, base) {
    let value = 0,
      f = 1;
    while (n > 0) {
      f /= base;
      value += f * (n % base);
      n = Math.floor(n / base);
    }
    return value;
  }
  function prepare(artifact) {
    const observations = artifact.observations.map((r) => ({
      ...r,
      z: normalize(r.input, artifact.preprocessing),
    }));
    const distances = observations.map((r, i) =>
      Math.sqrt(
        Math.min(
          ...observations
            .filter((s, j) => j !== i)
            .map((s) => distance(r.z, s.z)),
        ),
      ),
    );
    return {
      artifact,
      observations,
      radius: Math.max(0.5, quantile(distances, 0.95) * 1.5),
    };
  }
  function suggest(context, ranges) {
    if (
      ranges.length !== 5 ||
      ranges.some(
        (r) =>
          r.length !== 2 || r.some((v) => !Number.isFinite(v)) || r[0] > r[1],
      )
    )
      throw Error("Each minimum must be at most its maximum.");
    const { artifact, observations, radius } = context,
      groups = new Map();
    let unsupported = 0;
    // Training years are a hard constraint; other preferences use proximity.
    const eligible = observations.filter(
      (r) => r.input[0] >= ranges[0][0] && r.input[0] <= ranges[0][1],
    );
    if (!eligible.length)
      return { suggestions: [], unsupported: 128, total: 128 };
    for (let n = 1; n <= 128; n++) {
      const input = ranges.map(
        ([lo, hi], j) => lo + (hi - lo) * halton(n, [2, 3, 5, 7, 11][j]),
      );
      const z = normalize(input, artifact.preprocessing),
        point = predict(artifact, input);
      const nearest = [...eligible].sort(
        (a, b) => distance(a.z, z) - distance(b.z, z),
      );
      if (Math.sqrt(distance(nearest[0].z, z)) > radius) {
        unsupported++;
        continue;
      }
      const spatial = [...observations].sort(
        (a, b) => distance(a.target, point) - distance(b.target, point),
      )[0].cluster;
      const best = Math.sqrt(distance(nearest[0].z, z));
      // Support several existing clusters if they have similarly compatible members.
      const seen = new Set();
      for (const row of nearest) {
        const d = Math.sqrt(distance(row.z, z));
        if (d > Math.min(radius, best + 0.35)) break;
        if (row.cluster === "noise" || seen.has(row.cluster)) continue;
        seen.add(row.cluster);
        if (!groups.has(row.cluster))
          groups.set(row.cluster, {
            cluster: row.cluster,
            name: row.name,
            count: 0,
            agreement: 0,
            points: [],
            inputs: [],
          });
        const g = groups.get(row.cluster);
        g.count++;
        g.agreement += Number(spatial === row.cluster);
        g.points.push(point);
        g.inputs.push(input);
      }
    }
    const suggestions = [...groups.values()]
      .map((g) => ({
        ...g,
        support: g.count / 128,
        agreement: g.agreement / g.count,
        point: [0, 1].map((j) =>
          quantile(
            g.points.map((p) => p[j]),
            0.5,
          ),
        ),
      }))
      .sort((a, b) => b.count + b.agreement - (a.count + a.agreement))
      .slice(0, 3);
    return { suggestions, unsupported, total: 128 };
  }
  return { forward, predict, prepare, suggest, quantile, normalize };
})();
