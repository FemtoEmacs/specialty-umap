const candidateContext=CandidateMap.prepare(candidateArtifact);
let candidateResult=null;
const candidateLabels=['Residency/fellowship duration (years)','Procedural profile','Scientific activity','Private practice (%)','Competitiveness'];
const candidateHelp=['Acceptable total postgraduate training.','0 = predominantly clinical; 5 = mixed; 10 = procedure dominant.','Relative research activity in this atlas. NIH grants per physician is a proxy for research opportunity.','Choose 0–100%. Values beyond the atlas range use the nearest supported percentage for matching.','Relative candidates per training position; willingness to face competition, not a prediction of admission.'];
const candidateFields=document.querySelector('.candidate-fields');
const candidateDomains=[0,1,2,3,4].map(j=>{
 const values=candidateArtifact.observations.map(r=>r.input[j]);
 return j===1?[0,10]:j===3?[0,100]:[Math.ceil(Math.min(...values)),Math.floor(Math.max(...values))];
});
for(let j=0;j<5;j++) {
 const field=document.createElement('fieldset'), legend=document.createElement('legend');legend.textContent=candidateLabels[j];field.append(legend);
 const relative=j===2||j===4;
 for(let bound=0;bound<2;bound++) {
  const label=document.createElement('label');label.textContent=bound===0?'From ':'To ';
  const input=document.createElement('input');input.type='number';input.required=true;input.id=`candidate-${j}-${bound}`;
  input.min=relative?0:candidateDomains[j][0];input.max=relative?100:candidateDomains[j][1];input.step="1";
  input.value=relative?(bound?100:0):candidateDomains[j][bound];label.append(input);field.append(label);
 }
 const help=document.createElement('small');help.textContent=candidateHelp[j]+(relative?' Use 0–100 percentile.':'');field.append(help);candidateFields.append(field);
}
const evaluation=candidateArtifact.evaluation;
document.querySelector('#candidate-quality').textContent=`Held-out atlas check: ${(evaluation.nearest_cluster_agreement*100).toFixed(0)}% nearest-cluster agreement across ${evaluation.held_out_count} specialties; coordinate RMSE ${evaluation.coordinate_rmse.toFixed(2)} (mean baseline ${evaluation.mean_baseline_rmse.toFixed(2)}). Placements are approximate; suggestions also use five-feature compatibility. This is not career-outcome validation.`;
function candidateRanges() {
 return candidateDomains.map((domain,j)=>{
  const pair=[0,1].map(b=>Number(document.querySelector(`#candidate-${j}-${b}`).value));
  if(pair[0]>pair[1]) throw Error(`${candidateLabels[j]}: the lower value must not exceed the upper value.`);
  if(j===1)return pair.map(value=>value/10);
  if(j===3){
   const values=candidateArtifact.observations.map(row=>row.input[3]);
   const minimum=Math.min(...values), maximum=Math.max(...values);
   return pair.map(value=>Math.max(minimum,Math.min(maximum,value)));
  }
  return j===2||j===4?pair.map(p=>CandidateMap.quantile(candidateArtifact.observations.map(r=>r.input[j]),p/100)):pair;
 });
}
function candidateRenderResults() {
 const container=document.querySelector('#candidate-results');container.replaceChildren();
 if(!candidateResult)return;
 const message=document.createElement('p');
 message.textContent=candidateResult.suggestions.length?'Compatible existing clusters (up to three). Each has support from members within your training-year range; other preferences use proximity. Range coverage can overlap; it is not a probability of satisfaction.':'No supported cluster for these ranges. Try adjusting a preference.';
 container.append(message);
 for(const group of candidateResult.suggestions) {
  const p=document.createElement('p'), title=document.createElement('strong');title.textContent=group.name;p.append(title);
  const years=candidateRanges()[0];
  const members=candidateArtifact.observations.filter(r=>r.cluster===group.cluster && r.input[0]>=years[0] && r.input[0]<=years[1]);
  const medians=[0,1,2,3,4].map(j=>CandidateMap.quantile(members.map(r=>r.input[j]),.5));
  const rank=(j,v)=>Math.round(100*candidateArtifact.observations.filter(r=>r.input[j]<=v).length/candidateArtifact.observations.length);
  p.append(document.createTextNode(` — ${Math.round(group.support*100)}% sampled-range coverage; ${Math.round(group.agreement*100)}% of its supported samples also project nearest this cluster. Typical members within your training range: ${medians[0].toFixed(1)} years; ${medians[1]<.25?'clinical':medians[1]>.75?'procedural':'mixed'} work; research percentile ${rank(2,medians[2])}; ${medians[3].toFixed(0)}% private practice; competitiveness percentile ${rank(4,medians[4])}.`));container.append(p);
 }
 if(candidateResult.unsupported){const p=document.createElement('p');p.textContent=`${candidateResult.unsupported} of ${candidateResult.total} sampled profiles were too far from the atlas data to support a suggestion.`;container.append(p);}
}
document.querySelector('#candidate-form').addEventListener('submit',event=>{
 event.preventDefault();try {
  candidateResult=CandidateMap.suggest(candidateContext,candidateRanges());
  familySelect.value=views.find(v=>v.field==='cluster_name').group;populateProperties();select.value='cluster_name';
  candidateRenderResults();draw();
 }catch(error){document.querySelector('#candidate-results').textContent=error.message;}
});
document.querySelector('#candidate-clear').addEventListener('click',()=>{candidateResult=null;candidateRenderResults();draw();});
document.querySelector('#candidate-markers').addEventListener('change',draw);
function drawCandidateOverlay(x,y) {
 if(!candidateResult)return;
 const ids=new Set(candidateResult.suggestions.map(g=>g.cluster));
 svg.append('g').attr('pointer-events','none').selectAll('circle').data(rows.filter(r=>ids.has(String(r.cluster_id)))).join('circle')
  .attr('cx',r=>x(r.x)).attr('cy',r=>y(r.y)).attr('r',10).attr('fill','none').attr('stroke','#111827').attr('stroke-width',2).attr('stroke-dasharray','3 3');
 if(!document.querySelector('#candidate-markers').checked)return;
 const marks=svg.append('g').attr('pointer-events','none').selectAll('g').data(candidateResult.suggestions).join('g').attr('transform',g=>`translate(${x(g.point[0])},${y(g.point[1])})`);
 marks.append('path').attr('d','M0,-9 L9,0 L0,9 L-9,0 Z').attr('fill','white').attr('stroke','#111827').attr('stroke-width',2);
 marks.append('text').attr('x',12).attr('y',-10).attr('font-size',12).text((g,i)=>`Profile ${i+1} (approx.)`);
}
