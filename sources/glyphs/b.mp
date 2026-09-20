input glyph;
beginglyph;

z0=(0, X);
z1=(x0 , 0);
paths[p] := z0{dir -80}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=point 0.8 of paths[p-1];
z1=(x0 + 0.45s, 0.9s);
z2=(x0 + 0.7s, 0.4s);
z3=(x0+0.1sw, 0);

paths[p] = z0{dir 80}..z1{right}..z2..{dir 170}z3;
pen_stroke(
   nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
