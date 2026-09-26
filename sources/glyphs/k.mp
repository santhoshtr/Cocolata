input glyph;
beginglyph;

z0=(0, X);
z1=(x0 , 0);
z2=(x1+ 0.6sw, 0.9s);
z3=(x2,0);
paths[p] := z0{dir -80}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0 = point 0 of paths[0] + (0.5sw, -0.6s);
z1 = point 0.85 of paths[0];
paths[p]:=z0{dir 245}..z1;
pen_stroke(
  nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0 = point 0.7 of paths[p-1];
z1 = point 1 of paths[0] + (0.6sw,0);
paths[p]:=z0--z1;
pen_stroke(
  nib(thicknib)(0,1)
)(paths[p])(strokes[p]);
anchor( "top", (xpart(point 0 of paths[0]), 1.2X));
endglyph;

