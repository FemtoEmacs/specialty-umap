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
  const eligible=rows.filter(r=>r.question_values[0]>=questions[0][0] && r.question_values[0]<=questions[0][1]);
  if(!eligible.length)return {suggestion:null,supported:0,total:128,known:known.filter(Boolean).length};
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
  // Require a clear majority across the admitted ranges and observed contexts.
  return {suggestion:agreement>=.55?{...best,agreement,point:[0,1].map(j=>quantile(best.points.map(p=>p[j]),.5))}:null,
          ambiguous:agreement<.55,supported,total:128,known:known.filter(Boolean).length};
 }
 return {forward,predict,prepare,questionValue,suggest,normalize,quantile};
})();
