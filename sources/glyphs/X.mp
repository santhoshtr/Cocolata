input glyph;
beginglyph;
r := 0.7;
z0=(0, 0.9X);
z1=(x0 + r*Xw, 0.1X);

paths[p] = z0{dir -60}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

p:=p+1;
clearxy;
z0=(0, 0.1X);
z1=(x0 + r*Xw, 0.9X);
paths[p] = z0{dir 55}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

% X
endglyph;
