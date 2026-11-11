import com.cburch.logisim.file.*;
import com.cburch.logisim.circuit.*;
import com.cburch.logisim.comp.*;
import com.cburch.logisim.instance.*;
import com.cburch.logisim.std.wiring.Pin;
import com.cburch.logisim.data.*;
import com.cburch.logisim.proj.Project;
import java.io.*;import java.nio.file.*;import java.util.*;
import java.awt.*;import java.awt.image.BufferedImage;import javax.imageio.ImageIO;
class LogisimVerify {
 public static void main(String[] args)throws Exception {
  String root=args[0]; int checks=0;
  for(String name:new String[]{"rs_latch","d_latch","d_ff","jk_ff","d_ff_async"}) {
   var file=LogisimFile.load(new File(root+"/logisim/"+name+".circ"),new Loader(null));
   var circuit=file.getMainCircuit();var project=new Project(file);var state=project.getCircuitState();
   Map<String,com.cburch.logisim.comp.Component> pins=new HashMap<>();
   for(var c:circuit.getNonWires())if(c.getFactory() instanceof Pin)pins.put(c.getAttributeSet().getValue(StdAttr.LABEL),c);
   var lines=Files.readAllLines(Path.of(root+"/results/"+name+"_vectors.tsv"));
   var log=new PrintWriter(root+"/results/"+name+"_logisim.csv");log.println("step,case,Q,expected,status");int step=0;
   for(String line:lines){String[] cols=line.split("\t");
    for(String pair:cols[0].split(",")){String[] kv=pair.split("=");var c=pins.get(kv[0]);((Pin)c.getFactory()).setValue(state.getInstanceState(c),kv[1].equals("1")?Value.TRUE:Value.FALSE);state.markComponentAsDirty(c);}
    state.getPropagator().propagate();
    String q=state.getValue(pins.get("q").getLocation()).toDisplayString();
    boolean ok=cols[1].equals("-")||q.equals(cols[1]);
    if(cols.length>3)ok &= state.getValue(pins.get("qn").getLocation()).toDisplayString().equals(cols[3]);
    if(state.getPropagator().isOscillating())ok=false;
    log.println((++step)+","+cols[2]+","+q+","+cols[1]+","+(ok?"PASS":"FAIL"));log.flush();
    if(!ok)throw new RuntimeException(name+" "+line+" got "+q);
    if(!cols[1].equals("-"))checks++;
   }
   log.close();
   var b=circuit.getBounds();int w=b.getX()+b.getWidth()+70,h=b.getY()+b.getHeight()+70;
   var img=new BufferedImage(w*2,h*2,BufferedImage.TYPE_INT_RGB);var g=img.createGraphics();g.scale(2,2);g.setColor(Color.WHITE);g.fillRect(0,0,w,h);g.setColor(Color.BLACK);
   var context=new ComponentDrawContext(null,circuit,state,g,g,true);context.setShowState(false);circuit.draw(context,Collections.emptySet());g.dispose();ImageIO.write(img,"png",new File(root+"/schematics/"+name+"_logisim.png"));
   System.out.println("PASS "+name+" ("+step+" steps)");
  }
  System.out.println("PASS: "+checks+" expected-Q checks in actual Logisim engine");System.exit(0);
 }
}
