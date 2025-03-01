input glyph;
beginglyph;

z0=(0, s);
z1=(x0  ,-descent);
paths[p] := z0{dir -80}..z1;
pen_stroke(
   nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=(xpart point 0.2 of paths[p-1], 0.6s);
z1=(0.56*x2, 0.95s);
z2=(x0 + 0.8sw, 0.52s);
z3=(0.46*x2, undershoot);
z4=(xpart point 0.52 of paths[p-1], 0);
paths[p] := z0{dir 60}..z1 ..z2 ..z3 ..z4;
paths[p] :=  harmonize(  paths[p] );
pen_stroke(
   nib(thicknib)(0,1,2, 3,4)
)(paths[p])(strokes[p]);

lbearing:=sw/3*0.1;
rbearing:=sw/3*0.2;
endglyph;
