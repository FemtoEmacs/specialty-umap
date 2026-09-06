/* Gaussian RBF inference; no UMAP fitting or optimization in the browser. */
globalThis.NineCandidate = (()=>{
 const distance=(a,b,known)=>a.reduce((s,v,i)=>s+(!known||known[i]?(v-b[i])**2:0),0);
 const normalize=(x,p)=>x.map((v,i)=>(v-p.means[i])/p.scales[i]);
 const quantile=(values,p)=>{const a=[...values].sort((a,b)=>a-b),t=(a.length-1)*p,i=Math.floor(t);return a[i]+(a[Math.min(i+1,a.length-1)]-a[i])*(t-i);};
 function forward(model,input){
  if(input.length!==model.centers[0].length||input.some(v=>!Number.isFinite(v)))throw Error('Invalid nine-feature input');
  const out=model.weights[0].map(()=>0);
  model.centers.forEach((c,i)=>{const k=Math.exp(-distance(c,input)/(2*model.width**2));model.weights[i].forEach((w,j)=>out[j]+=k*w);});return out;
 }
 function predict(a,input){
  const out=forward(a.model,normalize(input,a.preprocessing)),scores=out.slice(2);
  return {point:out.slice(0,2).map((v,i)=>v*a.target_preprocessing.scales[i]+a.target_preprocessing.means[i]),cluster:a.classes[scores.indexOf(Math.max(...scores))],scores};
 }
 function prepare(a){
  const rows=a.observations.map(r=>({...r,z:normalize(r.input,a.preprocessing)}));
  const distances=rows.map((r,i)=>Math.sqrt(Math.min(...rows.filter((s,j)=>i!==j).map(s=>distance(r.z,s.z)))));
  return {a,rows,radius:Math.max(.5,quantile(distances,.95)*1.5)};
 }
 // Piecewise mapping for numerical questions; percentiles already live in z space.
 function questionValue(a,j,value){
  if([2,4,5,7].includes(j))return quantile(a.observations.map(r=>r.input[j]),value/100);
  const raw=j===1?value/10:value;
  const byValue=new Map();for(const r of a.observations){const q=r.question_values[j];if(!byValue.has(q))byValue.set(q,[]);byValue.get(q).push(r.input[j]);}
  const anchors=[...byValue].map(([x,ys])=>[x,ys.reduce((s,y)=>s+y,0)/ys.length]).sort((a,b)=>a[0]-b[0]);
  if(raw<=anchors[0][0])return anchors[0][1];if(raw>=anchors.at(-1)[0])return anchors.at(-1)[1];
  const i=anchors.findIndex(p=>p[0]>=raw),[x0,y0]=anchors[i-1],[x1,y1]=anchors[i];return y0+(y1-y0)*(raw-x0)/(x1-x0);
 }
 function halton(n,b){let v=0,f=1;while(n>0){f/=b;v+=f*(n%b);n=Math.floor(n/b);}return v;}
 function suggest(ctx,questions){
  if(questions.length!==9 || questions.some(r=>!Array.isArray(r)||r.length!==2||r.some(v=>!Number.isFinite(v))||r[0]>r[1]))throw Error('Enter a valid range for all nine preferences.');
  if(questions.some((r,j)=>r[0]<0 || (j===1&&r[1]>10) || ([2,3,4,5,7,8].includes(j)&&r[1]>100)))throw Error('A preference is outside its allowed scale.');
  const {a,rows,radius}=ctx,known=questions.map(r=>r!==null),ranges=questions.map((r,j)=>r?.map(v=>questionValue(a,j,v)));
  const eligible=rows.filter(r=>r.question_values[0]>=questions[0][0] && r.question_values[0]<=questions[0][1] && r.question_values[6]>=questions[6][0]);
  if(!eligible.length)return {suggestion:null,supported:0,total:128,known:known.filter(Boolean).length};
  ranges[6]=[questionValue(a,6,questions[6][0]),Math.max(...eligible.map(r=>r.input[6]))];
  const groups=new Map();let supported=0;
  for(let n=1;n<=128;n++){
   const input=ranges.map((r,j)=>r?r[0]+(r[1]-r[0])*halton(n,[2,3,5,7,11,13,17,19,23][j]):a.preprocessing.means[j]);
   const z=normalize(input,a.preprocessing),donors=[...eligible].sort((r,s)=>distance(r.z,z,known)-distance(s.z,z,known));
   if(Math.sqrt(distance(donors[0].z,z,known))>radius)continue;
   const contexts=[input];
   for(const context of contexts){
    const full=normalize(context,a.preprocessing);
    if(Math.sqrt(Math.min(...eligible.map(r=>distance(r.z,full))))>radius)continue;
    const prediction=predict(a,context);
    // A cluster must contain at least one member inside the training-year constraint.
    if(prediction.cluster==='noise'||!eligible.some(r=>r.cluster===prediction.cluster))continue;
    const w=1/contexts.length;supported+=w;
    if(!groups.has(prediction.cluster))groups.set(prediction.cluster,{cluster:prediction.cluster,name:rows.find(r=>r.cluster===prediction.cluster).name,votes:0,points:[]});
    const g=groups.get(prediction.cluster);g.votes+=w;g.points.push(prediction.point);
   }
  }
  const sorted=[...groups.values()].sort((a,b)=>b.votes-a.votes),best=sorted[0];
  if(!best)return {suggestion:null,supported,total:128,known:known.filter(Boolean).length};
  const agreement=best.votes/supported;
  const points=sorted.flatMap(group=>group.points);
  const profilePoint=[0,1].map(j=>quantile(points.map(p=>p[j]),.5));
  // Require a clear majority across the admitted ranges and observed contexts.
  return {suggestion:agreement>=.55?{...best,agreement,point:[0,1].map(j=>quantile(best.points.map(p=>p[j]),.5))}:null,
          profilePoint,ambiguous:agreement<.55,supported,total:128,known:known.filter(Boolean).length};
 }

 // Search only inside the user's ranges. Never relax a stated limit to force a match.
 function adjustment(ctx,original){
  const initial=suggest(ctx,original);if(initial.suggestion)return null;
  const copy=q=>q.map(r=>[...r]),cache=new Map();let evaluations=0;
  const assess=q=>{const key=JSON.stringify(q);if(!cache.has(key)){evaluations++;cache.set(key,suggest(ctx,q));}return cache.get(key);};
  const changes=q=>q.flatMap((r,j)=>r[0]===original[j][0]&&r[1]===original[j][1]?[]:[{field:j,before:[...original[j]],after:[...r]}]);
  const cost=q=>changes(q).reduce((sum,c)=>sum+1-(c.after[1]-c.after[0])/(c.before[1]-c.before[0]||1),0);
  const acceptable=r=>r.suggestion&&r.supported/r.total>=.25;
  let best=null;
  const consider=q=>{const result=assess(q);if(!acceptable(result))return;const proposal={ranges:copy(q),result,changes:changes(q),cost:cost(q)};
   if(!best||proposal.changes.length<best.changes.length||(proposal.changes.length===best.changes.length&&proposal.cost<best.cost))best=proposal;};
  for(let j=0;j<9;j++){
   if(j===6)continue;
   const [lo,hi]=original[j];if(lo===hi)continue;const mid=Math.floor((lo+hi)/2);
   for(const range of [...[.125,.25,.5,.75,.875].flatMap(f=>{const cut=Math.round(lo+(hi-lo)*f);return [[lo,cut],[cut,hi]];}),[mid,mid],[lo,lo],[hi,hi]]){const q=copy(original);q[j]=range;consider(q);}
  }
  if(!best){
   const anchors=ctx.rows.filter(r=>r.question_values[0]>=original[0][0]&&r.question_values[0]<=original[0][1]&&r.question_values[6]>=original[6][0]).map(row=>{
    const q=row.question_values.map((raw,j)=>{
     if(j===6)return [...original[6]];
     let v=raw;if(j===1)v=raw*10;
     if([2,4,5,7].includes(j)){const values=ctx.rows.map(r=>r.input[j]).sort((a,b)=>a-b);v=100*values.indexOf(row.input[j])/(values.length-1);}
     v=Math.max(original[j][0],Math.min(original[j][1],Math.round(v)));return [v,v];
    });return q;
   });
   for(const q of anchors.slice(0,24)){
    if(!acceptable(assess(q)))continue;
    for(let j=0;j<9;j++){const trial=copy(q);trial[j]=[...original[j]];if(acceptable(assess(trial)))q[j]=trial[j];}
    consider(q);if(best&&best.changes.length<=2)break;
   }
  }
  return best?{...best,evaluations}:null;
 }
 return {forward,predict,prepare,questionValue,suggest,adjustment,normalize,quantile};
})();
