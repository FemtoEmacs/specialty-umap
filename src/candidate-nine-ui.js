const nineContext = NineCandidate.prepare(nineArtifact);
let nineResult = null;
let nineProposal = null;
let nineOriginal = null;
let nineApplied = false;
const nineLabels = [
  "Residency/fellowship duration (years)",
  "Procedural profile",
  "Scientific activity",
  "Private practice (%)",
  "Competitiveness",
  "Clinical work intensity",
  "Minimum acceptable salary (thousands of US dollars)",
  "Physician availability",
  "Female representation in the specialty (%)",
];
const nineHelp = [
  "Minimum accredited training; some completed pathways take longer.",
  "0 = clinical; 5 = mixed; 10 = procedure dominant.",
  "Desired research activity, from low (0) to high (100).",
  "0–100%; values beyond observed data use the nearest supported percentage.",
  "Willingness to face competitive entry, from low (0) to high (100).",
  "Desired clinical intensity, from low (0) to high (100).",
  "For example, 260 means $260,000 or more. Higher salaries are acceptable; there is no upper limit.",
  "Desired specialty context: low (0) to high (100) physicians per patient burden.",
  "Desired workplace composition, not your personal sex or gender. Use 0–100 for a broad preference.",
];
const nineDomains = nineLabels.map((_, j) =>
  j === 0
    ? [
        Math.ceil(
          Math.min(
            ...nineArtifact.observations.map((r) => r.question_values[0]),
          ),
        ),
        Math.ceil(
          Math.max(
            ...nineArtifact.observations.map((r) => r.question_values[0]),
          ),
        ),
      ]
    : j === 1
      ? [0, 10]
      : j === 6
        ? [0, 2000]
        : [0, 100],
);
for (let j = 0; j < 9; j++) {
  const field = document.createElement("fieldset"),
    legend = document.createElement("legend");
  legend.textContent = nineLabels[j];
  field.append(legend);
  for (let b = 0; b < 2; b++) {
    const label = document.createElement("label");
    label.textContent = j === 6 ? "At least " : b ? "To " : "From ";
    if (j === 6 && b === 1) label.hidden = true;
    const input = document.createElement("input");
    input.type = "number";
    input.id = `nine-${j}-${b}`;
    input.min = nineDomains[j][0];
    input.max = nineDomains[j][1];
    input.step = "1";
    input.required = true;
    input.value =
      j === 6
        ? b
          ? Math.ceil(
              Math.max(
                ...nineArtifact.observations.map((r) => r.question_values[6]),
              ),
            )
          : Math.floor(
              Math.min(
                ...nineArtifact.observations.map((r) => r.question_values[6]),
              ),
            )
        : nineDomains[j][b];
    label.append(input);
    field.append(label);
  }
  const help = document.createElement("small");
  help.textContent = nineHelp[j];
  field.append(help);
  document
    .querySelector(j < 5 ? "#nine-main-fields" : "#nine-extra-fields")
    .append(field);
}
const nineCV = nineArtifact.evaluation;
document.querySelector("#candidate-quality").textContent =
  `Five-fold grouped validation: ${nineCV.correct}/${nineCV.total} (${Math.round((100 * nineCV.correct) / nineCV.total)}%) cluster labels correct with all nine measured specialty features; nearest-neighbor baseline ${nineCV.nearest_neighbor_correct}/${nineCV.total}. With only five measured features known: ${nineCV.five_known_correct}/${nineCV.total} (${Math.round((100 * nineCV.five_known_correct) / nineCV.total)}%). Coordinate placements recovered ${nineCV.coordinate_cluster_correct}/${nineCV.total} clusters. These evaluate specialty records, not career satisfaction or questionnaire validity. The final model is refitted on all atlas records. AWRS-SMC found no better map recipe in the tested search.`;
function nineQuestions() {
  return nineLabels.map((label, j) => {
    if (j === 6) {
      const raw = String(document.querySelector("#nine-6-0").value).trim(),
        minimum = Number(raw);
      if (!raw || !Number.isInteger(minimum) || minimum < 0 || minimum > 2000)
        throw Error("Enter a whole-number minimum salary from 0 to 2000.");
      return [
        minimum,
        Math.max(
          minimum,
          Math.ceil(
            Math.max(
              ...nineArtifact.observations.map((r) => r.question_values[6]),
            ),
          ),
        ),
      ];
    }
    const values = [0, 1].map((b) =>
      String(document.querySelector(`#nine-${j}-${b}`).value).trim(),
    );
    if (values.some((v) => v === ""))
      throw Error(`${label}: both limits are required.`);
    const r = values.map(Number);
    if (
      r.some((v) => !Number.isInteger(v)) ||
      r[0] > r[1] ||
      r[0] < nineDomains[j][0] ||
      r[1] > nineDomains[j][1]
    )
      throw Error(
        `${label}: enter whole numbers within the shown limits, with From no greater than To.`,
      );
    return r;
  });
}
function nineResults() {
  const container = document.querySelector("#candidate-results");
  container.replaceChildren();
  if (!nineResult) return;
  const p = document.createElement("p");
  if (!nineResult.suggestion) {
    p.textContent = nineResult.ambiguous
      ? "These ranges do not support one clear cluster. The optional diamond shows the median predicted position across supported profiles, not an assigned specialty or cluster. It may lie between clusters. Narrow one or more preferences for a more specific result."
      : "No supported cluster for these ranges. Adjust a preference to explore other options.";
    container.append(p);
    nineAdjustmentPanel(container);
    return;
  }
  const g = nineResult.suggestion,
    title = document.createElement("strong");
  title.textContent = g.name;
  p.append(title);
  p.append(
    document.createTextNode(
      ` — ${Math.round(g.agreement * 100)}% agreement across supported preference samples. All nine dimensions included; this agreement is not a probability of career satisfaction.`,
    ),
  );
  container.append(p);
  const support = document.createElement("p");
  support.textContent = `${Math.round((100 * nineResult.supported) / nineResult.total)}% of sampled profiles had support in the atlas. The highlighted cluster contains members within your training-year range; not every member necessarily fits.`;
  container.append(support);
  nineAdjustmentPanel(container);
}
function nineAdjustmentPanel(container) {
  if (!nineProposal) {
    if (nineOriginal && !nineResult.suggestion) {
      const note = document.createElement("p");
      note.textContent =
        "No supported narrowing was found in the tested adjustments. Your limits have not been changed.";
      container.append(note);
    }
    return;
  }
  const box = document.createElement("section"),
    heading = document.createElement("strong");
  heading.textContent = nineApplied
    ? "Applied adjustment"
    : "Proposed adjustment";
  box.append(heading);
  const text = document.createElement("p");
  text.textContent = nineApplied
    ? "These changes were applied; you can restore your original ranges."
    : "Narrowing the ranges below produces a supported cluster in this model. Your original inputs remain unchanged until you apply it.";
  box.append(text);
  const table = document.createElement("table");
  const header = document.createElement("tr");
  for (const name of ["Preference", "Original", "Proposed"]) {
    const cell = document.createElement("th");
    cell.textContent = name;
    header.append(cell);
  }
  table.append(header);
  for (const c of nineProposal.changes) {
    const row = document.createElement("tr");
    for (const value of [
      nineLabels[c.field],
      c.before.join("–"),
      c.after.join("–"),
    ]) {
      const cell = document.createElement("td");
      cell.textContent = value;
      cell.style.padding = "6px 14px 6px 0";
      row.append(cell);
    }
    table.append(row);
  }
  box.append(table);
  const outcome = document.createElement("p"),
    g = nineProposal.result.suggestion;
  outcome.textContent =
    "Result: " +
    g.name +
    " — " +
    Math.round(g.agreement * 100) +
    "% agreement among supported samples; " +
    Math.round(
      (100 * nineProposal.result.supported) / nineProposal.result.total,
    ) +
    "% sample support. This is a model-based what-if, not evidence that your preferences should change.";
  box.append(outcome);
  const button = document.createElement("button");
  button.type = "button";
  button.textContent = nineApplied
    ? "Restore original ranges"
    : "Apply proposed ranges";
  button.addEventListener("click", () => {
    nineApplied = !nineApplied;
    const ranges = nineApplied ? nineProposal.ranges : nineOriginal;
    ranges.forEach((r, j) =>
      r.forEach(
        (v, b) => (document.querySelector("#nine-" + j + "-" + b).value = v),
      ),
    );
    nineResult = nineApplied
      ? nineProposal.result
      : NineCandidate.suggest(nineContext, nineOriginal);
    if (nineApplied)
      document.querySelector("#candidate-markers").checked = true;
    nineResults();
    draw();
  });
  box.append(button);
  container.append(box);
}
document
  .querySelector("#candidate-form")
  .addEventListener("submit", (event) => {
    event.preventDefault();
    try {
      nineOriginal = nineQuestions().map((r) => [...r]);
      nineProposal = null;
      nineApplied = false;
      nineResult = NineCandidate.suggest(nineContext, nineOriginal);
      if (!nineResult.suggestion)
        nineProposal = NineCandidate.adjustment(nineContext, nineOriginal);
      familySelect.value = views.find((v) => v.field === "cluster_name").group;
      populateProperties();
      select.value = "cluster_name";
      nineResults();
      draw();
    } catch (error) {
      document.querySelector("#candidate-results").textContent = error.message;
    }
  });
document.querySelector("#candidate-form").addEventListener("input", (event) => {
  if (event.target.id === "candidate-markers") return;
  nineResult = null;
  nineProposal = null;
  nineOriginal = null;
  nineApplied = false;
  nineResults();
  draw();
});
document.querySelector("#candidate-clear").addEventListener("click", () => {
  nineResult = null;
  nineProposal = null;
  nineOriginal = null;
  nineApplied = false;
  nineResults();
  draw();
});
document.querySelector("#candidate-markers").addEventListener("change", draw);
function drawNineOverlay(x, y) {
  const g = nineResult?.suggestion;
  const point = g?.point || nineResult?.profilePoint;
  if (!point) return;
  if (g)
    svg
      .append("g")
      .attr("pointer-events", "none")
      .selectAll("circle")
      .data(rows.filter((r) => String(r.cluster_id) === g.cluster))
      .join("circle")
      .attr("cx", (r) => x(r.x))
      .attr("cy", (r) => y(r.y))
      .attr("r", 10)
      .attr("fill", "none")
      .attr("stroke", "#111827")
      .attr("stroke-width", 2)
      .attr("stroke-dasharray", "3 3");
  if (!document.querySelector("#candidate-markers").checked) return;
  const marker = svg
    .append("g")
    .attr("pointer-events", "none")
    .attr("transform", `translate(${x(point[0])},${y(point[1])})`);
  marker
    .append("path")
    .attr("d", "M0,-9 L9,0 L0,9 L-9,0 Z")
    .attr("fill", "white")
    .attr("stroke", "#111827")
    .attr("stroke-width", 2);
  marker
    .append("text")
    .attr("x", 12)
    .attr("y", -10)
    .attr("font-size", 12)
    .text(g ? "Profile (approx.)" : "Profile (uncertain)");
}
