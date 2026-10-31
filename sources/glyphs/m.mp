input glyph;
beginglyph;


z0=(0, s-overshoot);
z1=(x0 + 0.1sw, undershoot);
paths[p] := z0{dir -60}...{dir -90}z1;
pen_stroke(
     nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=point infinity of paths[p-1];
z1=(0.5(x0+x2), 0.8s);
z2=(x0 + 0.66sw, undershoot);
z3=(x2 + 0.3sw, 0.8s);
z4 =(x3 + 0.3sw, 0);

paths[p] := z0{dir 80}...{dir 0}z1{dir 0}...{dir -80}z2{dir 80}...{dir 0}z3{dir 0}...{dir -80}z4;
%  paths[p] :=  harmonize(paths[p] );
pen_stroke(
   nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);



endglyph;
