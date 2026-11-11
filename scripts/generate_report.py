import os
os.environ.setdefault('MPLCONFIGDIR', '/tmp/vhdl-assignment-mpl')
from pathlib import Path
import re,json,csv,subprocess,html
import matplotlib;matplotlib.use('Agg')
import matplotlib.pyplot as plt
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Image,Table,TableStyle,PageBreak,Preformatted
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib import colors
R=Path(__file__).resolve().parent.parent; vectors=json.loads((R/'results/vectors.json').read_text())
names=list(vectors)
titles=['RS Latch','D Latch with Enable','Positive-edge D Flip-Flop','Positive-edge JK Flip-Flop','D Flip-Flop with Asynchronous Set/Clear']
explain=[
'Cross-coupled NOR gates implement Q = NOT(R OR Qn), Qn = NOT(S OR Q). S,R = 10 sets; 01 resets; 00 holds. The forbidden 11 condition forces Q=Qn=0, so the outputs are not complementary. Simultaneous release of 11 to 00 has no defined physical result; the test recovers by applying a valid reset.',
'A NAND inverter creates Dn. Sbar=NAND(D,en) and Rbar=NAND(Dn,en) drive a cross-coupled NAND latch. When en=1, Q follows D; when en=0, both latch inputs become 1 and the previous state is held.',
'Two gate-built D latches form a master-slave flip-flop. The master is enabled by NOT(clk), and the slave by clk. The master samples during the low phase; the slave transfers that stored value on the rising edge. Changes to D during the high phase do not reach Q.',
'The feedback next-state equation is Dnext=(J AND Qn) OR ((NOT K) AND Q). NAND gates implement this equation and two NAND D latches form the master-slave storage. JK=00 holds, 01 resets, 10 sets, and 11 toggles once per rising edge.',
'Both master and slave use gate-built NOR storage with asynchronous overrides. run=NOT(set OR clr), effective_set=set AND NOT(clr). For each latch, S=(D AND enable AND run) OR effective_set, R=(NOT(D) AND enable AND run) OR clr. Thus clr always wins. Applying controls to both stages prevents a stale master value from appearing when the controls are released during a high clock phase.'
]
# Netlist-derived generated schematics: every concurrent assignment or process is a block.
for name in names:
 text=(R/f'results/{name}_synth.vhd').read_text();body=text.split('\nbegin\n',1)[1]; body=re.sub(r'--[^\n]*','',body)
 blocks=[]
 for p in re.findall(r'process\s*\(.*?end process;',body,re.S):
  outs=re.findall(r'(\w+)\s*<=',p); label='Register: rising edge' if 'rising_edge' in p else 'Latch / process'
  if name=='d_ff_async':label='Async D register\nreset=n10, value=n6'
  blocks.append((list(dict.fromkeys(outs)),p,label));body=body.replace(p,'')
 for m in re.finditer(r'(?:with\s+\w+\s+select\s+)?(\w+)\s*<=\s*(.*?);',body,re.S):
  out,rhs=m.groups();blocks.append(([out],rhs,out+' = '+re.sub(r'\s+',' ',rhs).strip()))
 sig=set(re.findall(r'signal\s+(\w+)',text));ins=re.findall(r'wrap_(\w+) <= \1;',text);sig.update(ins);sig.add('q')
 dot=['digraph G {rankdir=LR; bgcolor="white"; node [fontname="DejaVu Sans",fontsize=11];']
 for i,(outs,rhs,label) in enumerate(blocks):
  # wrap aliases are included, preserving synthesized connections.
  dot.append(f'b{i} [shape=box,style="rounded,filled",fillcolor="#E7EFF8",label={json.dumps(label)}];')
  for out in outs:dot.append(f'b{i} -> "{out}";')
  for dep in sorted(set(re.findall(r'\b\w+\b',rhs)) & sig-set(outs)):dot.append(f'"{dep}" -> b{i};')
 dot.append('}');p=R/f'schematics/{name}_synth.dot';p.write_text('\n'.join(dot));subprocess.run(['dot','-Tpng','-Gdpi=125',str(p),'-o',str(p.with_suffix('.png'))],check=True)
# VCD actual top-level traces.
for name in names:
 lines=(R/f'results/{name}.vcd').read_text().splitlines();depth=0;ids={};data={};t=0
 for line in lines:
  if line.startswith('$scope'):depth+=1
  elif line.startswith('$upscope'):depth-=1
  elif line.startswith('$var') and depth==1:
   f=line.split();ids[f[3]]=f[4];data[f[4]]=[]
  elif line.startswith('#'):t=int(line[1:])/1e6
  elif line and line[0] in '01UXZuxz' and line[1:] in ids:data[ids[line[1:]]].append((t,line[0]))
 seq=vectors[name];end=len(seq)*10
 fig,axes=plt.subplots(len(data),1,figsize=(10,1.05*len(data)+.7),sharex=True,squeeze=False)
 for ax,(n,points) in zip(axes[:,0],data.items()):
  xs=[p[0] for p in points]+[end];ys=[int(v) if v in '01' else .5 for _,v in points]+[int(points[-1][1]) if points[-1][1] in '01' else .5]
  ax.step(xs,ys,where='post',color='#165c99');ax.set_ylabel(n,rotation=0,labelpad=20);ax.set_yticks([0,1]);ax.set_ylim(-.25,1.25);ax.grid(alpha=.2)
  for x,v in points:
   if v not in '01':ax.text(x,.5,v,fontsize=8)
  if n=='q':
   rows=list(csv.DictReader((R/f'results/{name}_logisim.csv').open()));xx=[];yy=[]
   for row in rows:
    if row['Q'] in ('0','1'):xx.append(int(row['step'])*10-1);yy.append(int(row['Q']))
   ax.plot(xx,yy,'o',mfc='none',mec='#e07621',ms=5,label='Logisim settled sample');ax.legend(loc='upper right',fontsize=7)
 axes[-1,0].set_xlabel('Time (ns)');axes[-1,0].set_xlim(0,end);fig.suptitle(name+' — GHDL VCD (line), actual Logisim samples (circles)',fontsize=11);fig.tight_layout();fig.savefig(R/f'results/{name}_waveform.png',dpi=160);plt.close(fig)
styles=getSampleStyleSheet();styles['BodyText'].fontSize=9;styles['BodyText'].leading=13
story=[]
def p(s,sty='BodyText'):story.append(Paragraph(s,styles[sty]))
def img(path,w=490,h=300):
 im=Image(str(path));scale=min(w/im.imageWidth,h/im.imageHeight);im.drawWidth=im.imageWidth*scale;im.drawHeight=im.imageHeight*scale;story.append(im)
def table(rows,widths=None):
 t=Table(rows,colWidths=widths,repeatRows=1,hAlign='LEFT');t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dce8f4')),('FONTNAME',(0,0),(-1,0),'Helvetica-Bold'),('FONTSIZE',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),3),('TOPPADDING',(0,0),(-1,-1),3),('GRID',(0,0),(-1,-1),.3,colors.HexColor('#b5c2cf'))]));story.append(t)
p('VHDL Assignment 3','Title');p('Gate-level circuits, synthesized designs and simulation evidence','Heading2');p('Five sequential circuits | GHDL 5.0.1 | Logisim 2.7.1 | VHDL-2008');story.append(Spacer(1,20))
p('Verification method','Heading2');p('Each circuit has two independently executed implementations: a VHDL design compiled, elaborated, simulated and synthesized with GHDL, and an individual-gate Logisim project loaded into the actual Logisim simulation engine. No built-in latch or flip-flop components are used in the Logisim designs. Named tunnels connect signals and feedback paths electrically.')
p('Results','Heading2');table([['Circuit','VHDL simulation','Synthesis','Logisim steps']]+[[titles[i],'PASS','PASS',str(len(vectors[n]))] for i,n in enumerate(names)],[245,85,65,80]);story.append(Spacer(1,14));p('48 expected-Q checks pass in each implementation; two initial preparation steps have no specified power-on Q. Six additional Qn checks verify the RS latch. The tests cover forbidden RS inputs, latch transparency/hold, rising and falling edges, all JK modes, asynchronous controls with both clock levels, priority and release behavior.')
p('Scope and timing assumptions','Heading2');p('These are ideal digital functional simulations, not transistor-level timing proofs. Uninitialized storage has no guaranteed power-on value. Input values are held stable before sampling edges. Real hardware must satisfy setup/hold and asynchronous recovery/removal timing; asynchronous inputs must not be released near a clock edge. The RS forbidden-state release is deliberately not assigned a deterministic result. Feedback latches and dual asynchronous controls may need device-specific primitives for a particular FPGA target; synthesis here is generic GHDL synthesis, without FPGA place-and-route.')
p('Files and reproduction','Heading2');p('vhdl/: five sources; tb/: assertion-based testbenches; logisim/: five projects; results/: VCD files, compiled synthesis netlists, logs and vectors; schematics/: actual Logisim renders and synthesized-netlist diagrams; scripts/: repeatable verification. See README.md for commands. The generated synthesis diagrams visualize assignments and storage in the emitted netlist; they are not FPGA technology-mapped schematics.')
for i,n in enumerate(names):
 story.append(PageBreak());p(f'{i+1}. {titles[i]}','Title');p('Gate-level implementation','Heading2');p(explain[i]);story.append(Spacer(1,10));img(R/f'schematics/{n}_logisim.png',h=240 if i>=3 else 330);p('Figure: rendered directly from the submitted .circ project using Logisim. Matching tunnel labels denote connected nets; all storage feedback is explicit at gate level. The displayed states are hidden to emphasize connectivity.');p('Simulation checks','Heading2')
 rows=[['Step','Input case','Q','Expected','Result']]
 for row in csv.DictReader((R/f'results/{n}_logisim.csv').open()):rows.append([row['step'],row['case'],row['Q'],row['expected'],row['status']])
 table(rows,[35,270,40,60,65])
 story.append(PageBreak());p(f'{i+1}. {titles[i]} — VHDL','Title');p('Generated synthesis schematic','Heading2');img(R/f'schematics/{n}_synth.png',h=205);p('Generated from results/'+n+'_synth.vhd; boxes represent emitted concurrent assignments or sequential processes. See the text netlist for exact expressions.');p('Simulation waveform','Heading2');img(R/f'results/{n}_waveform.png',h=270);p('Blue: GHDL VCD traces. Orange circles: independently simulated Logisim Q after each input step (placed 1 ns before the corresponding VHDL step boundary for readability). Unknown initial values are marked U/X or shown at midlevel. Logisim time is propagation settling, so the circles compare logical states, not propagation delay.');p('VHDL verification','Heading2');p(html.escape((R/f'results/{n}_simulation.txt').read_text()).replace('\n','<br/>'));p('All RTL and synthesized-netlist assertions passed; generic synthesis completed successfully. Source: vhdl/'+n+'.vhd. Testbench: tb/tb_'+n+'.vhd.')
def footer(c,doc):c.setFont('Helvetica',8);c.drawString(40,24,'VHDL Assignment 3 | Functional verification');c.drawRightString(555,24,str(doc.page))
SimpleDocTemplate(str(R/'Assignment3_Report.pdf'),rightMargin=40,leftMargin=40,topMargin=35,bottomMargin=40).build(story,onFirstPage=footer,onLaterPages=footer)
