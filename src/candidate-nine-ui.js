const nineContext=NineCandidate.prepare(nineArtifact);let nineResult=null;
const nineLabels=['Residency/fellowship duration (years)','Procedural profile','Scientific activity','Private practice (%)','Competitiveness','Clinical work intensity','Annual salary (thousands of US dollars)','Physician availability','Female representation in the specialty (%)'];
const nineHelp=['Minimum accredited training; some completed pathways take longer.','0 = clinical; 5 = mixed; 10 = procedure dominant.','Desired research activity, from low (0) to high (100).','0–100%; values beyond observed data use the nearest supported percentage.','Willingness to face competitive entry, from low (0) to high (100).','Desired clinical intensity, from low (0) to high (100).','Desired annual compensation, for example 300 = $300,000.','Desired specialty context: low (0) to high (100) physicians per patient burden.','Desired workplace composition, not your personal sex or gender. Use 0–100 for a broad preference.'];
const nineDomains=nineLabels.map((_,j)=>j===0?[Math.ceil(Math.min(...nineArtifact.observations.map(r=>r.question_values[0]))),Math.ceil(Math.max(...nineArtifact.observations.map(r=>r.question_values[0])))]:j===1?[0,10]:j===6?[0,2000]:[0,100]);
for(let j=0;j<9;j++){
 const field=document.createElement('fieldset'),legend=document.createElement('legend');legend.textContent=nineLabels[j];field.append(legend);
 for(let b=0;b<2;b++){
  const label=document.createElement('label');label.textContent=b?'To ':'From ';
  const input=document.createElement('input');input.type='number';input.id=`nine-${j}-${b}`;input.min=nineDomains[j][0];input.max=nineDomains[j][1];input.step='1';input.required=true;
  input.value=j===6?(b?Math.ceil(Math.max(...nineArtifact.observations.map(r=>r.question_values[6]))):Math.floor(Math.min(...nineArtifact.observations.map(r=>r.question_values[6])))):nineDomains[j][b];
  label.append(input);field.append(label);
 }
 const help=document.createElement('small');help.textContent=nineHelp[j];field.append(help);document.querySelector(j<5?'#nine-main-fields':'#nine-extra-fields').append(field);
}
const nineCV=nineArtifact.evaluation;
document.querySelector('#candidate-quality').textContent=`Five-fold grouped validation: ${nineCV.correct}/${nineCV.total} (${Math.round(100*nineCV.correct/nineCV.total)}%) cluster labels correct with all nine measured specialty features; nearest-neighbor baseline ${nineCV.nearest_neighbor_correct}/${nineCV.total}. With only five measured features known: ${nineCV.five_known_correct}/${nineCV.total} (${Math.round(100*nineCV.five_known_correct/nineCV.total)}%). Coordinate placements recovered ${nineCV.coordinate_cluster_correct}/${nineCV.total} clusters. These evaluate specialty records, not career satisfaction or questionnaire validity. The final model is refitted on all atlas records. AWRS-SMC found no better map recipe in the tested search.`;
function nineQuestions(){return nineLabels.map((label,j)=>{
 const values=[0,1].map(b=>String(document.querySelector(`#nine-${j}-${b}`).value).trim());
 if(values.some(v=>v===''))throw Error(`${label}: both limits are required.`);
 const r=values.map(Number);
 if(r.some(v=>!Number.isInteger(v))||r[0]>r[1]||r[0]<nineDomains[j][0]||r[1]>nineDomains[j][1])throw Error(`${label}: enter whole numbers within the shown limits, with From no greater than To.`);return r;
});}
function nineResults(){
 const container=document.querySelector('#candidate-results');container.replaceChildren();if(!nineResult)return;
 const p=document.createElement('p');
 if(!nineResult.suggestion){p.textContent=nineResult.ambiguous?'These ranges do not support one clear cluster. Narrow one or more preferences.':'No supported cluster for these ranges. Adjust a preference to explore other options.';container.append(p);return;}
 const g=nineResult.suggestion,title=document.createElement('strong');title.textContent=g.name;p.append(title);
 p.append(document.createTextNode(` — ${Math.round(g.agreement*100)}% agreement across supported preference samples. All nine dimensions included; this agreement is not a probability of career satisfaction.`));container.append(p);
 const support=document.createElement('p');support.textContent=`${Math.round(100*nineResult.supported/nineResult.total)}% of sampled profiles had support in the atlas. The highlighted cluster contains members within your training-year range; not every member necessarily fits.`;container.append(support);
}
document.querySelector('#candidate-form').addEventListener('submit',event=>{event.preventDefault();try{
 nineResult=NineCandidate.suggest(nineContext,nineQuestions());
 familySelect.value=views.find(v=>v.field==='cluster_name').group;populateProperties();select.value='cluster_name';nineResults();draw();
}catch(error){document.querySelector('#candidate-results').textContent=error.message;}});
document.querySelector('#candidate-form').addEventListener('input',event=>{if(event.target.id==='candidate-markers')return;nineResult=null;nineResults();draw();});
document.querySelector('#candidate-clear').addEventListener('click',()=>{nineResult=null;nineResults();draw();});
document.querySelector('#candidate-markers').addEventListener('change',draw);
function drawNineOverlay(x,y){
 const g=nineResult?.suggestion;if(!g)return;
 svg.append('g').attr('pointer-events','none').selectAll('circle').data(rows.filter(r=>String(r.cluster_id)===g.cluster)).join('circle').attr('cx',r=>x(r.x)).attr('cy',r=>y(r.y)).attr('r',10).attr('fill','none').attr('stroke','#111827').attr('stroke-width',2).attr('stroke-dasharray','3 3');
 if(!document.querySelector('#candidate-markers').checked)return;
 const marker=svg.append('g').attr('pointer-events','none').attr('transform',`translate(${x(g.point[0])},${y(g.point[1])})`);
 marker.append('path').attr('d','M0,-9 L9,0 L0,9 L-9,0 Z').attr('fill','white').attr('stroke','#111827').attr('stroke-width',2);
 marker.append('text').attr('x',12).attr('y',-10).attr('font-size',12).text('Profile (approx.)');
}
