input glyph;
beginglyph;

z0=(0, s);
z1=(x0  ,-descent);
paths[p] := z0{dir -80}..{down}z1;
pen_stroke(
   nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=(xpart point 0.2 of paths[p-1], 0.1s);
z1=(0.56*x2, 0.9s);
z2=(x0 + 0.8sw, 0.5s);
z3=(xpart point 0.52 of paths[p-1], 0.1s);
paths[p] := z0{dir 80}..{dir 30}z1 ..z2..z3;
paths[p] :=  harmonize(  paths[p] );
pen_stroke(
   nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);

lbearing:=sw/3*0.1;
rbearing:=sw/3*0.2;
endglyph;
