const fs=require('node:fs'),assert=require('node:assert/strict'),vm=require('node:vm');
require('../src/candidate-nine-engine.js');const {artifact:a,fixtures}=JSON.parse(fs.readFileSync(require('node:path').join(__dirname,'../output/candidate-nine-model.json'),'utf8'));
let error=0;for(const f of fixtures){const p=NineCandidate.predict(a,f.input);assert.equal(p.cluster,f.expected.cluster);for(let j=0;j<2;j++){error=Math.max(error,Math.abs(p.point[j]-f.expected.point[j]));assert.ok(Math.abs(p.point[j]-f.expected.point[j])<1e-8);}}
const ctx=NineCandidate.prepare(a),unchanged=JSON.stringify(a);
const q=[[3,9],[0,10],[0,100],[0,100],[0,100],[0,100],[100,1000],[0,100],[0,100]];
assert.deepEqual(NineCandidate.suggest(ctx,q),NineCandidate.suggest(ctx,q));
assert.throws(()=>NineCandidate.suggest(ctx,[]));assert.throws(()=>NineCandidate.suggest(ctx,[...q.slice(0,8),null]));assert.throws(()=>NineCandidate.suggest(ctx,[[9,3],...q.slice(1)]));
assert.equal(NineCandidate.suggest(ctx,[[0,0],...q.slice(1)]).suggestion,null);
assert.ok(Math.abs(NineCandidate.questionValue(a,3,0)-Math.min(...a.observations.map(r=>r.input[3])))<1e-10);
assert.ok(Math.abs(NineCandidate.questionValue(a,3,100)-Math.max(...a.observations.map(r=>r.input[3])))<1e-10);
const lo=NineCandidate.questionValue(a,1,0),hi=NineCandidate.questionValue(a,1,10);
assert.ok(Math.abs(NineCandidate.questionValue(a,1,3)-(lo+.3*(hi-lo)))<1e-7);
let found=0;
for(const r of a.observations.slice(0,25)){
 const questions=r.question_values.map((v,j)=>{let q=v;if([2,4,5,7].includes(j)){const sorted=a.observations.map(s=>s.input[j]).sort((a,b)=>a-b);q=100*sorted.indexOf(r.input[j])/(sorted.length-1);}if(j===1)q=v*10;return [q,q];});
 const result=NineCandidate.suggest(ctx,questions);if(result.suggestion){found++;assert.ok(result.suggestion.point.every(Number.isFinite));assert.ok(a.observations.some(s=>s.cluster===result.suggestion.cluster&&s.question_values[0]===r.question_values[0]));}
}
assert.ok(found>=20);assert.equal(JSON.stringify(a),unchanged);
const page=fs.readFileSync(require('node:path').join(__dirname,'../output/specialty-candidate.html'),'utf8');const old=fs.readFileSync(require('node:path').join(__dirname,'../output/specialty-umap.html'),'utf8');for(const name of ['problem','rows']){const re=new RegExp('const '+name+' = ([^\\n]+);');assert.equal(page.match(re)[1],old.match(re)[1]);}
const script=page.match(/<script type="module">([\s\S]*?)<\/script>/)[1];new vm.Script(script.replace(/^\s*import .*;$/gm,''));
console.log(`PASS: ${fixtures.length} Lisp/JS RBF predictions; maximum error ${error}; range conversion, abstention, no mutation, single-cluster examples, atlas preservation and page syntax.`);
// Execute questionnaire setup against a small DOM test double (no browser).
const elements=new Map();
class Element {
 constructor(tag){this.tag=tag;this.children=[];this.listeners={};}
 set id(value){this._id=value;elements.set('#'+value,this);}get id(){return this._id;}
 append(...children){this.children.push(...children);}
 replaceChildren(...children){this.children=children;}
 addEventListener(type,fn){this.listeners[type]=fn;}
}
for(const id of ['nine-main-fields','nine-extra-fields','candidate-quality','candidate-form','candidate-clear','candidate-markers','candidate-results']){const e=new Element('div');e.id=id;}
const document={createElement:tag=>new Element(tag),createTextNode:text=>({text}),querySelector:selector=>elements.get(selector)};
const context={NineCandidate,nineArtifact:a,document,draw:()=>{}};vm.createContext(context);
vm.runInContext(fs.readFileSync(require('node:path').join(__dirname,'../src/candidate-nine-ui.js'),'utf8'),context);
for(let j=0;j<9;j++)for(let b=0;b<2;b++){const e=elements.get(`#nine-${j}-${b}`);assert.equal(e.required,true);assert.notEqual(e.disabled,true);assert.equal(e.step,'1');}
assert.equal(elements.get('#nine-1-1').max,10);assert.equal(elements.get('#nine-3-0').min,0);assert.equal(elements.get('#nine-3-1').max,100);
assert.equal(context.nineQuestions().length,9);
elements.get('#nine-1-0').value='3';assert.equal(context.nineQuestions()[1][0],3);
elements.get('#nine-8-0').value='';assert.throws(()=>context.nineQuestions());
console.log('PASS: all nine fields required, 18 whole-number bounds, procedure 0–10, private practice 0–100, missing workplace context rejected.');

const screenshotRanges=[[1,6],[0,10],[0,60],[40,80],[0,80],[30,100],[260,988],[0,100],[20,80]];
const screenshotResult=NineCandidate.suggest(ctx,screenshotRanges);
assert.equal(screenshotResult.ambiguous,true);assert.equal(screenshotResult.suggestion,null);
assert.equal(screenshotResult.profilePoint.length,2);assert.ok(screenshotResult.profilePoint.every(Number.isFinite));
assert.equal(NineCandidate.suggest(ctx,[[0,0],...screenshotRanges.slice(1)]).profilePoint,undefined);
console.log('PASS: screenshot profile has an approximate position without a forced cluster; unsupported profiles have no fabricated marker.');
const beforeAdjustment=JSON.stringify(screenshotRanges);
const proposal=NineCandidate.adjustment(ctx,screenshotRanges);
assert.ok(proposal&&proposal.result.suggestion);assert.ok(proposal.result.supported/proposal.result.total>=.25);
assert.equal(JSON.stringify(screenshotRanges),beforeAdjustment);
assert.equal(proposal.changes.length,1);
proposal.ranges.forEach((r,j)=>{assert.ok(r[0]>=screenshotRanges[j][0]&&r[1]<=screenshotRanges[j][1]);assert.ok(r.every(Number.isInteger));});
assert.deepEqual(proposal.result,NineCandidate.suggest(ctx,proposal.ranges));
assert.equal(NineCandidate.adjustment(ctx,proposal.ranges),null);
assert.equal(NineCandidate.adjustment(ctx,[[0,0],...screenshotRanges.slice(1)]),null);
// Exercise preview, explicit apply, and restore through the form callbacks.
Element.prototype.style={};
context.familySelect={value:''};context.select={value:''};context.views=[{field:'cluster_name',group:'Clusters'}];context.populateProperties=()=>{};
screenshotRanges.forEach((r,j)=>r.forEach((v,b)=>elements.get(`#nine-${j}-${b}`).value=String(v)));
elements.get('#candidate-form').listeners.submit({preventDefault(){}});
assert.equal(JSON.stringify(context.nineQuestions()),beforeAdjustment);
const descendants=e=>[e,...(e.children||[]).flatMap(descendants)];
const apply=descendants(elements.get('#candidate-results')).find(e=>e.textContent==='Apply proposed ranges');assert.ok(apply);apply.listeners.click();
assert.equal(JSON.stringify(context.nineQuestions()),JSON.stringify(proposal.ranges));assert.equal(elements.get('#candidate-markers').checked,true);
assert.ok(vm.runInContext('nineResult.suggestion',context));
const restore=descendants(elements.get('#candidate-results')).find(e=>e.textContent==='Restore original ranges');assert.ok(restore);restore.listeners.click();
assert.equal(JSON.stringify(context.nineQuestions()),beforeAdjustment);
console.log('PASS: adjustment search preserves limits, yields verified result, previews changes, applies explicitly and restores original inputs.');
const salaryExact=screenshotRanges.map(r=>[...r]);salaryExact[6]=[260,260];
assert.deepEqual(NineCandidate.suggest(ctx,salaryExact),NineCandidate.suggest(ctx,screenshotRanges));
const salaryProposal=NineCandidate.adjustment(ctx,salaryExact);
if(salaryProposal){assert.deepEqual(salaryProposal.ranges[6],[260,260]);assert.ok(salaryProposal.changes.every(c=>c.field!==6));}
const unavailableSalary=screenshotRanges.map(r=>[...r]);unavailableSalary[6]=[2000,2000];assert.equal(NineCandidate.suggest(ctx,unavailableSalary).suggestion,null);
console.log('PASS: salary is a minimum only, higher salaries remain eligible, adjustment never raises the minimum, and unsupported salary thresholds abstain.');
