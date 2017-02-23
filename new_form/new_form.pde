//Made by Maxim Kondratovich minsk-maxim@mail.ru
//2016-2017
import g4p_controls.*;

float x,y,f,d,n;
float a,b,c,fi,rad;
float delta_fi,scale;
float x0o,y0o,xOfs,yOfs;
boolean plusEnable,minusEnable,moveEnable,rayDrawing;
int dots;
ArrayList<Ray> rays;
float alpha[];
float rAlph;

GTextField textfield1;
GTextField textfield2;
GTextField textfield3;
GTextField textfield4;
GTextField txtAlpha0;
GTextField txtAlpha1;
GTextField txtAlpha2;
GTextField txtAlpha3;
GTextField txtR1;
GTextField txtR2;
GCheckbox checkbox1; 
GCheckbox checkbox2;
GCheckbox checkbox3; 
GCheckbox DrawRays; 

void setup() {
  size(1200, 600);
  
  d=180;
  f=220;
  n=1.5;
  
  a = n*n-1;
  c = pow(n*(d+f),2)-pow(d+n*f,2);
  
  delta_fi = 0.002;
  scale = 1;
  
  xOfs = yOfs = 0;
  
  plusEnable = minusEnable = true;
  moveEnable = true;
  rayDrawing = true;
  
  dots = 0;
  
  rays = new ArrayList();
  rays.add(new Ray());
  rays.add(new Ray());
  rays.add(new Ray());
  rays.add(new Ray());
  
  alpha = new float[]{0.1,0.2,2*PI-0.1,2*PI-0.2};
  
  rAlph = 0;
  
  frameRate(999);//Means unlimited
  
  createGUI();
}
void draw(){
  
  background(255);
  fill(0);
  text(( mouseX - width/2 - xOfs)/scale +" ; "+ ( mouseY - height/2 -yOfs )/scale ,0,35);
  
  text("d",90,14);
  text("f",160,14);
  text("n",230,14);
  text("delta fi",297,14);
  text(frameRate,0,10);
  text("alpha0",1,54);
  text("alpha1",1,80);
  text("alpha2",1,106);
  text("alpha3",1,132);
  text("R1",25,155);
  text("R2",25,181);
  
  DrawAxises();
  
  fill(200,0,0);
  noStroke();
  ellipse( d*scale + width/2 + xOfs, 0.5 + height/2 + yOfs, 3, 3);
  text("d",d*scale + width/2 + xOfs,15 + height/2 + yOfs);
  
  ellipse( (d+f)*scale + width/2 + xOfs, 0.5 + height/2 + yOfs, 3, 3);
  text("f",(d+f)*scale + width/2 + xOfs,15 + height/2 + yOfs);
  fill(0);
  stroke(0);
  ellipse(width/2 + xOfs, height/2 + yOfs,3,3);
  
  text("dots: "+dots,0,height-1);
  dots = 0;
  
  float fiMax = acos((d+n*f+sqrt((n*n-1)*(pow(n*(d+f),2)-pow(d+n*f,2))))/(n*n*(d+f)));
  
  
    fi = fiMax;
    float rr = -_b(fiMax)/(2*a);
    float rx = rr*cos(fi);
    float ry = rr*sin(fi);
    float ang = atan(ry/(d+f-rx));
    float fr = sqrt(pow(d+f-rx,2)+pow(ry,2));
    rad = fr;
    stroke(255,0,0);
    noFill();
    arc((d+f)*scale+ width/2 + xOfs, height/2 + yOfs,2*fr*scale,2*fr*scale,PI-ang,PI+ang);
    stroke(0);
  
  for( fi = -fiMax; fi < fiMax; fi += delta_fi ){
     float[] rs = r();
     
     rs[0] = rs[0]*scale;
     rs[1] = rs[1]*scale;
     
     if(plusEnable){
       stroke(0,0,255);
       point( rs[0]*cos(fi) + width/2 + xOfs, rs[0]*sin(fi) + height/2 + yOfs);
     }
     
     if(minusEnable){
     stroke(255,0,0);
     point( rs[1]*cos(fi) + width/2 + xOfs, rs[1]*sin(fi) + height/2 + yOfs);
     }
     
     stroke(0);
  }
  
  if(rayDrawing)
    DrawRay();
    
    DrawP();
    
    //float rR=100*sqrt(abs(cos(2*rAlph)))*cos(2*rAlph)/abs(cos(2*rAlph));
    //float xx=rR*cos(rAlph),yy=rR*sin(rAlph);
    
    
    
    //txtR1.setText(xx+";"+yy);
    //txtR2.setText(xx+";"+yy);
    //rAlph += 0.07;
    
    
    //saveFrame("frames3/###.png");
  
  //DrawR();
}
void DrawP(){
 float x_, y_ ;
 for(x_=0;x_<width;x_+=1){
  y_ = sqrt((pow(d+f-x_,2)-pow(x_*n*(d+f-1),2))/(pow(n*(d+f-1),2)-1)); 
  fill(0);
  stroke(0);
  ellipse(x_*scale+ width/2 + xOfs,y_*scale+ height/2 + yOfs,3,3); //<>//
 }
}
float[] r(){
  float[] rs = new float[2];
  
  b = _b(fi);
    
  if(plusEnable){
    rs[0] = (-b+sqrt(b*b-4*a*c))/(2*a);
    if(rs[0]<=0 || rs[0]>=d+n*f)
      rs[0] = 0;
    else
      dots++;
  }
  
  if(minusEnable){
    rs[1] = (-b-sqrt(b*b-4*a*c))/(2*a);
    if(rs[1]<=0 || rs[1]>=d+n*f)
      rs[1] = 0;
    else
      dots++;
  }
  
  return rs;
}

float _b(float angle){
  return 2*(d+n*f)-2*n*n*(d+f)*cos(angle);
}

void ReCalculate(){
  a = n*n-1;
  c = pow(n*(d+f),2)-pow(d+n*f,2);
}

void DrawRay(){
  float coords[];
  
   for(int i=0;i<4;i++){
     
    if(i<2)
      coords = float(split(txtR1.getText(),';'));
      else
       coords = float(split(txtR2.getText(),';'));
    
    float b0 = _b(alpha[i]);
    float r0 = (-b0-sqrt(b0*b0-4*a*c))/(2*a);
    float x0 = r0*cos(alpha[i]), y0 = r0*sin(alpha[i]);
    float gamma;
    stroke(0);
  
    float k1 = r0, k2 = sqrt(pow(d+f-x0,2)+y0*y0);
    float alphaN = atan( y0*(1/k1+n/k2)/(x0*(1/k1+n/k2)-(d+f)*n/k2) );
    
    //Normal drawing
    if(true){
     float yn1 = y0*0.5, yn2 = y0*1.5, xn1 = (yn1-y0)/tan(alphaN)+x0, xn2 = (yn2-y0)/tan(alphaN)+x0;
     line( xn1*scale+width/2+xOfs , yn1*scale+height/2+yOfs , xn2*scale+width/2+xOfs , yn2*scale+height/2+yOfs );
    }
  
     if(i == 0){
      stroke(0,255,0);
     }
     else{
      stroke(0,0,255);
     }
     
     stroke(0);
     
    if(alpha[i] > PI){
    
     rays.set(i,new Ray(coords[0],coords[1],atan( (coords[1]-y0)/(coords[0]-x0))));
     line(rays.get(i).x*scale+width/2+xOfs,rays.get(i).y*scale+height/2+yOfs,x0*scale+width/2+xOfs,y0*scale+height/2+yOfs);
     gamma = asin(sin(2*PI+abs(alphaN)-rays.get(i).angle)/n);
     float alphaR = abs(alphaN)-gamma;
     
     float xo,yo;
     float ao=tan(alphaR)*tan(alphaR)+1, bo=2*tan(alphaR)*y0-2*x0*tan(alphaR)*tan(alphaR)-2*(d+f), co=pow(x0*tan(alphaR),2)+y0*y0-2*tan(alphaR)*x0*y0+pow(d+f,2)-rad*rad;
     xo = (-bo-sqrt(bo*bo-4*ao*co))/(2*ao);
     yo = tan(alphaR)*(xo-x0)+y0;
     
     line(x0*scale+width/2+xOfs , y0*scale+height/2+yOfs ,xo*scale+width/2+xOfs , yo*scale+height/2+yOfs);
     
     float alphaNo = 2*PI - atan(yo/(d+f-xo));
     //Normal drawing
     if(true){
       float yn1 = yo*0.85, yn2 = yo*1.15, xn1 = (yn1-yo)/tan(alphaNo)+xo, xn2 = (yn2-yo)/tan(alphaNo)+xo;
       line( xn1*scale+width/2+xOfs , yn1*scale+height/2+yOfs , xn2*scale+width/2+xOfs , yn2*scale+height/2+yOfs );
      }
      
      float gammao = asin(n*sin(alphaNo-alphaR)); 
      
      float alphaRo = -( alphaNo-gammao);
      line(xo*scale+width/2+xOfs , yo*scale+height/2+yOfs ,1500*scale+width/2+xOfs,((1500-xo)*tan(PI-alphaRo)+yo)*scale+height/2+yOfs);
     
    }
    else{
       
     rays.set(i,new Ray(coords[0],coords[1],atan( (y0-coords[1])/(x0-coords[0]))));
     line(rays.get(i).x*scale+width/2+xOfs,rays.get(i).y*scale+height/2+yOfs,x0*scale+width/2+xOfs,y0*scale+height/2+yOfs);
     gamma = asin(sin(abs(alphaN)+rays.get(i).angle)/n);
     
     float alphaR = abs(alphaN)-gamma;
     
     alphaR*=-1;
     float xo,yo;
     float ao=tan(alphaR)*tan(alphaR)+1, bo=2*tan(alphaR)*y0-2*x0*tan(alphaR)*tan(alphaR)-2*(d+f), co=pow(x0*tan(alphaR),2)+y0*y0-2*tan(alphaR)*x0*y0+pow(d+f,2)-rad*rad;
     xo = (-bo-sqrt(bo*bo-4*ao*co))/(2*ao);
     yo = tan(alphaR)*(xo-x0)+y0;
     line(x0*scale+width/2+xOfs , y0*scale+height/2+yOfs ,xo*scale+width/2+xOfs , yo*scale+height/2+yOfs);
     
     float alphaNo = 2*PI - atan(yo/(d+f-xo));
     //Normal drawing
     if(true){
       float yn1 = yo*0.85, yn2 = yo*1.15, xn1 = (yn1-yo)/tan(alphaNo)+xo, xn2 = (yn2-yo)/tan(alphaNo)+xo;
       line( xn1*scale+width/2+xOfs , yn1*scale+height/2+yOfs , xn2*scale+width/2+xOfs , yn2*scale+height/2+yOfs );
      }
      
      float gammao = asin(n*sin(alphaNo-alphaR)); 
      
      float alphaRo = -( alphaNo-gammao);
      line(xo*scale+width/2+xOfs , yo*scale+height/2+yOfs ,1500*scale+width/2+xOfs,((1500-xo)*tan(PI-alphaRo)+yo)*scale+height/2+yOfs);
    }
  }
}
void DrawR(){
  fi = acos((d+n*f+sqrt((n*n-1)*(pow(n*(d+f),2)-pow(d+n*f,2))))/(n*n*(d+f)));
  b=_b(fi);
  
  float rr = -b/(2*a)*scale;
  stroke(0);
  noFill();
  arc(width/2 + xOfs,height/2 + yOfs,2*rr,2*rr,-fi,fi);
     
  line(width/2 + xOfs,height/2 + yOfs,rr*cos(fi)+width/2 + xOfs,rr*sin(fi)+height/2 + yOfs);
  line(width/2 + xOfs,height/2 + yOfs,rr*cos(fi)+width/2 + xOfs,-rr*sin(fi)+height/2 + yOfs); //<>//
}
//Scaling
void mouseWheel(MouseEvent event) {
  
  if(event.getCount() == 1)
    scale *= 0.8;
  else
    scale /= 0.8;
}
//Moving
void mousePressed() {
  x0o = mouseX - xOfs;
  y0o = mouseY - yOfs;
}
void mouseDragged() 
{
  if(moveEnable){
    xOfs = mouseX - x0o;
    yOfs = mouseY - y0o;
  }
}
void mouseReleased() {
  x0o = mouseX;
  y0o = mouseY;
}
void DrawAxises(){
   stroke(0);
   strokeWeight(1);
   
   line(0,height/2+yOfs,width,height/2+yOfs);
   text("X",width-10,height/2+20+yOfs);
   
   line(width/2+xOfs,0,width/2+xOfs,height);
   text("Y",width/2+10+xOfs,height);
}
void createGUI(){
 G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
 G4P.messagesEnabled(false);
    
 textfield1 = new GTextField(this, 105, 1, 50, 20, G4P.SCROLLBARS_NONE);
 textfield1.setText(str(d));
 textfield1.addEventHandler(this, "textfield1_change1");
  
 textfield2 = new GTextField(this, 170, 1, 50, 20, G4P.SCROLLBARS_NONE);
 textfield2.setText(str(f));
 textfield2.addEventHandler(this, "textfield2_change1");
  
 textfield3 = new GTextField(this, 240, 1, 50, 20, G4P.SCROLLBARS_NONE);
 textfield3.setText(str(n));
 textfield3.addEventHandler(this, "textfield3_change1");
  
 textfield4 = new GTextField(this, 340, 1, 50, 20, G4P.SCROLLBARS_NONE);
 textfield4.setText(str(delta_fi));
 textfield4.addEventHandler(this, "textfield4_change1");
  
 txtAlpha0 = new GTextField(this, 40, 40, 50, 20, G4P.SCROLLBARS_NONE);
 txtAlpha0.setText(str(alpha[0]));
 txtAlpha0.addEventHandler(this, "txtAlpha0_change1");
  
 txtAlpha1 = new GTextField(this, 40, 65, 50, 20, G4P.SCROLLBARS_NONE);
 txtAlpha1.setText(str(alpha[1]));
 txtAlpha1.addEventHandler(this, "txtAlpha1_change1");
 
 txtAlpha2 = new GTextField(this, 40, 90, 50, 20, G4P.SCROLLBARS_NONE);
 txtAlpha2.setText(str(alpha[2]));
 txtAlpha2.addEventHandler(this, "txtAlpha2_change1");
 
 txtAlpha3 = new GTextField(this, 40, 115, 50, 20, G4P.SCROLLBARS_NONE);
 txtAlpha3.setText(str(alpha[3]));
 txtAlpha3.addEventHandler(this, "txtAlpha3_change1");
  
 txtR1 = new GTextField(this, 40, 140, 50, 20, G4P.SCROLLBARS_NONE);
 txtR1.setText("0;0");
 txtR1.addEventHandler(this, "txtR1_change1");
 
 txtR2 = new GTextField(this, 40, 165, 50, 20, G4P.SCROLLBARS_NONE);
 txtR2.setText("0;0");
 txtR2.addEventHandler(this, "txtR2_change1");
  
 checkbox1 = new GCheckbox(this, 400, 0, 64, 20);
 checkbox1.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
 checkbox1.setText("+ (blue)");
 checkbox1.setSelected(true);
 checkbox1.addEventHandler(this, "checkbox1_select");
  
 checkbox2 = new GCheckbox(this, 470, 0, 60, 20);
 checkbox2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
 checkbox2.setText("- (red)");
 checkbox2.setSelected(true);
 checkbox2.addEventHandler(this, "checkbox2_select");
  
 checkbox3 = new GCheckbox(this, 530, 0, 100, 20);
 checkbox3.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
 checkbox3.setText("Enable moving");
 checkbox3.setSelected(true);
 checkbox3.addEventHandler(this, "checkbox3_select");
 
 DrawRays = new GCheckbox(this, 630, 0, 100, 20);
 DrawRays.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
 DrawRays.setText("Refract rays");
 DrawRays.setSelected(true);
 DrawRays.addEventHandler(this, "DrawRays_select");
}

void textfield1_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     d = float(source.getText());
     ReCalculate();
   }
 }
}

void textfield2_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     f = float(source.getText());
     ReCalculate();
   }
 }
}
void textfield3_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(int(source.getText())>0){
     n = float(source.getText());
     ReCalculate();
   }
 }
}
void textfield4_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     delta_fi = float(source.getText());
   }
 }
}
void txtAlpha0_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     alpha[0] = float(source.getText());
   }
 }
}
void txtAlpha1_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     alpha[1] = float(source.getText());
   }
 }
}
void txtAlpha2_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     alpha[2] = float(source.getText());
   }
 }
}
void txtAlpha3_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(float(source.getText())>0){
     alpha[3] = float(source.getText());
   }
 }
}
void txtR1_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(source.getText().contains(";")){
     DrawRay();
   }
 }
}
void txtR2_change1(GTextField source, GEvent event) {
 if(event == GEvent.CHANGED){
   if(source.getText().contains(";")){
     DrawRay();
   }
 }
}
void checkbox1_select(GCheckbox source, GEvent event) {
 if (checkbox1.isSelected() == true) {
   plusEnable = true;
 }
 else {
   plusEnable = false;
 }
} 
void checkbox2_select(GCheckbox source, GEvent event) { 
 if (checkbox2.isSelected() == true) {
   minusEnable = true;
 }
 else {
   minusEnable = false;
 }
} 
void checkbox3_select(GCheckbox source, GEvent event) { 
 if (checkbox3.isSelected() == true) {
   moveEnable = true;
 }
 else {
   moveEnable = false;
 }
} 
void DrawRays_select(GCheckbox source, GEvent event) { 
 if (DrawRays.isSelected() == true) {
   rayDrawing = true;
 }
 else {
   rayDrawing = false;
 }
} 