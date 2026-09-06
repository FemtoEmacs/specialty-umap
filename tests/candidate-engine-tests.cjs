const fs=require('node:fs'),assert=require('node:assert/strict');
require('../src/candidate-engine.js');
const {artifact,fixtures}=JSON.parse(fs.readFileSync(new URL('../output/candidate-model.json',`file://${__filename}`),'utf8'));
let max=0;for(const f of fixtures){const actual=CandidateMap.predict(artifact,f.input);actual.forEach((v,i)=>{max=Math.max(max,Math.abs(v-f.expected[i]));assert.ok(Math.abs(v-f.expected[i])<1e-8);});}
const ctx=CandidateMap.prepare(artifact);
const all=[0,1,2,3,4].map(j=>[Math.min(...artifact.observations.map(r=>r.input[j])),Math.max(...artifact.observations.map(r=>r.input[j]))]);
const before=JSON.stringify(artifact.observations);
const result=CandidateMap.suggest(ctx,all);
assert.deepEqual(result,CandidateMap.suggest(ctx,all));
assert.ok(result.suggestions.length>1 && result.suggestions.length<=3);
assert.equal(new Set(result.suggestions.map(g=>g.cluster)).size,result.suggestions.length);
for(const g of result.suggestions){assert.ok(g.support>0 && g.support<=1);assert.ok(g.point.every(Number.isFinite));}
const extreme=CandidateMap.suggest(ctx,all.map(()=>[1e6,1e6]));assert.equal(extreme.suggestions.length,0);assert.equal(extreme.unsupported,128);
assert.throws(()=>CandidateMap.suggest(ctx,[[5,1],...all.slice(1)]));
assert.throws(()=>CandidateMap.suggest(ctx,[[NaN,1],...all.slice(1)]));
for(const r of artifact.observations.filter(r=>r.cluster!=='noise')){
 const exact=CandidateMap.suggest(ctx,r.input.map(v=>[v,v]));
 assert.ok(exact.suggestions.length>0,'Observed profile must be supported');
}
assert.equal(JSON.stringify(artifact.observations),before);
console.log(`PASS: ${fixtures.length} Lisp/JavaScript predictions agree (maximum error ${max}); deterministic multi-cluster, no mutation, invalid and unsupported cases.`);
const noYears=CandidateMap.suggest(ctx,[[0,0],...all.slice(1)]);assert.equal(noYears.suggestions.length,0);
for(const years of [3,4,5,6]) {
 const limited=CandidateMap.suggest(ctx,[[years,years],...all.slice(1)]);
 for(const g of limited.suggestions)assert.ok(artifact.observations.some(r=>r.cluster===g.cluster && r.input[0]===years));
}
console.log('PASS: training-year constraints are enforced for every suggested cluster.');
