input glyph;
beginglyph;
z0 = (0.75s, 0.9X);
z1 = (x0-s/3, X);
z2 = (x1-s/3, s);
z3 = (x2+s/6, s/2);
z4 = (thick/2, thick);

paths[0] := z0..z1..z2..z3..{dir 200}z4;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[0])(strokes[0]);

p:=p+1;
clearxy;
z0 = (0, thick/2);
z1 = (xpart point 0 of paths[0]+s/4, y0);
paths[p]=z0..z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0 = (0, 3/4s);
z1 = (xpart point 0 of paths[0], y0);
paths[p]=z0--z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);
endglyph;
