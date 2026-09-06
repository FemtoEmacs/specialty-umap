const fs=require('node:fs'),assert=require('node:assert/strict'),vm=require('node:vm'),path=require('node:path');
const root=path.join(__dirname,'..');require('../src/candidate-nine-engine.js');
const {artifact:a,fixtures}=JSON.parse(fs.readFileSync(path.join(root,'output/candidate-awrs-model.json')));
const reference=JSON.parse(fs.readFileSync(path.join(root,'output/candidate-nine-model.json'))).artifact;
let maxError=0;for(const f of fixtures){const p=NineCandidate.predict(a,f.input);assert.equal(p.cluster,f.expected.cluster);p.point.forEach((v,j)=>{maxError=Math.max(maxError,Math.abs(v-f.expected.point[j]));assert.ok(Math.abs(v-f.expected.point[j])<1e-8);});}
assert.equal(fixtures.length,117);assert.notDeepEqual(a.model.weights,reference.model.weights);
const html=fs.readFileSync(path.join(root,'awrs-smc.html'),'utf8');
const rows=JSON.parse(html.match(/const rows=(.*);/)[1]);assert.equal(rows.length,117);
for(const r of rows){const record=a.observations.find(o=>o.id===r.specialty_id);assert.deepEqual([r.x,r.y],record.target);assert.equal(r.cluster_id,record.cluster);assert.equal(r.cluster_name,record.name);}
assert.ok(html.includes('M-6 0H6 M0-6V6'));assert.ok(html.includes('candidate-form'));
const script=html.match(/<script type="module">([\s\S]*?)<\/script>/)[1];new vm.Script(script.replace(/^\s*import .*;$/gm,''));
const engine=fs.readFileSync(path.join(root,'src/candidate-nine-engine.js'),'utf8'),ui=fs.readFileSync(path.join(root,'src/candidate-nine-ui.js'),'utf8');assert.ok(html.includes(engine));
const q=[[1,6],[0,10],[0,60],[40,80],[0,80],[30,100],[260,988],[0,100],[20,80]],ctx=NineCandidate.prepare(a);
const before=JSON.stringify(q),initial=NineCandidate.suggest(ctx,q),proposal=NineCandidate.adjustment(ctx,q);assert.equal(JSON.stringify(q),before);
assert.ok(initial.suggestion||proposal);if(proposal){assert.ok(proposal.changes.every(c=>c.field!==6));assert.deepEqual(proposal.result,NineCandidate.suggest(ctx,proposal.ranges));}
const salary=q.map(r=>[...r]);salary[6]=[260,260];assert.deepEqual(NineCandidate.suggest(ctx,salary),initial);
const elements=new Map();class Element{constructor(tag){this.tag=tag;this.children=[];this.listeners={};this.style={};}set id(v){this._id=v;elements.set('#'+v,this);}get id(){return this._id;}append(...children){this.children.push(...children);}replaceChildren(...children){this.children=children;}addEventListener(event,fn){this.listeners[event]=fn;}}
for(const id of ['nine-main-fields','nine-extra-fields','candidate-quality','candidate-form','candidate-clear','candidate-markers','candidate-results']){const e=new Element('div');e.id=id;}
const document={createElement:t=>new Element(t),createTextNode:text=>({text}),querySelector:s=>elements.get(s)};
const context={NineCandidate,nineArtifact:a,document,draw:()=>{},familySelect:{},select:{},views:[{field:'cluster_name',group:'Clusters'}],populateProperties:()=>{}};vm.createContext(context);vm.runInContext(ui,context);
q.forEach((r,j)=>r.forEach((v,b)=>elements.get(`#nine-${j}-${b}`).value=v));
elements.get('#candidate-form').listeners.submit({preventDefault(){}});
assert.ok(vm.runInContext('nineResult.suggestion||nineProposal',context));
if(vm.runInContext('nineProposal',context)){
 const walk=e=>[e,...(e.children||[]).flatMap(walk)];walk(elements.get('#candidate-results')).find(e=>e.textContent==='Apply proposed ranges').listeners.click();
 assert.ok(vm.runInContext('nineResult.suggestion',context));assert.equal(elements.get('#candidate-markers').checked,true);
 walk(elements.get('#candidate-results')).find(e=>e.textContent==='Restore original ranges').listeners.click();assert.equal(elements.get('#nine-6-0').value,260);
}
console.log(`PASS: ${fixtures.length} alternative Lisp/JS predictions (max error ${maxError}); separate model and map coordinates, questionnaire, salary minimum, proposals and apply/restore.`);
const comparison=fs.readFileSync(path.join(root,'ref-awrs-smc-compar.html'),'utf8');
const panel=comparison.match(/<section>[\s\S]*?<\/section>/g)[2];let matched=0;
for(const m of panel.matchAll(/<title>(.*?) — (.*?); x=([\d.-]+), y=([\d.-]+)<\/title>/g)){
 const r=a.observations.find(r=>r.id===m[1]);assert.ok(r);assert.ok(Math.abs(r.target[0]-Number(m[3]))<.00051);assert.ok(Math.abs(r.target[1]-Number(m[4]))<.00051);
 assert.equal(m[2],r.cluster==='noise'?'Unclustered':'Cluster '+r.cluster);matched++;
}assert.equal(matched,117);
console.log('PASS: all 117 coordinates and cluster identities match the existing best-alternative comparison panel.');
