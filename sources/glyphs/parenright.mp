input glyph;
beginglyph;

z0 = ( 0, 0.95X);
z1 = ( x0+X/5, y0 - X/2);
z3 = ( x0, 0);

paths[0] = z0..z1..z3;

pen_stroke(
  nib(thicknib)(0,1,2)
)(paths[0])(strokes[0]);
lbearing:=lbearing*1.5;
rbearing:=rbearing*1.5;

endglyph;

