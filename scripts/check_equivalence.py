"""Compare actual top-level GHDL VCD Q against actual Logisim CSV samples."""
from pathlib import Path
import csv,json
R=Path(__file__).resolve().parent.parent
summary={}
for name,seq in json.loads((R/'results/vectors.json').read_text()).items():
 depth=0;code=None;time=0;events=[]
 for line in (R/f'results/{name}.vcd').read_text().splitlines():
  if line.startswith('$scope'):depth+=1
  elif line.startswith('$upscope'):depth-=1
  elif line.startswith('$var') and depth==1:
   fields=line.split()
   if fields[4]=='q':code=fields[3]
  elif line.startswith('#'):time=int(line[1:])
  elif code is not None and line[1:]==code and line[0] in '01UXZ':events.append((time,line[0]))
 rows=list(csv.DictReader((R/f'results/{name}_logisim.csv').open()));checks=0
 for i,row in enumerate(rows):
  if seq[i][1] is None:continue
  sample_time=(i+1)*10_000_000-1 # VCD uses 1 fs units; sample before next stimulus.
  v=next(value for t,value in reversed(events) if t<=sample_time)
  assert v==row['Q']==str(seq[i][1]),(name,i+1,v,row)
  checks+=1
 summary[name]={'status':'PASS','matching_Q_checks':checks}
(R/'results/equivalence_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print('PASS: actual GHDL/Logisim outputs match on',sum(x['matching_Q_checks'] for x in summary.values()),'specified Q samples')
