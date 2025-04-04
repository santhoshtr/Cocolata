input glyph;
beginglyph;
r := 0.8;
z0=(0, 0.9s);
z1=(x0 + r*sw, 0.1s);

paths[p] = z0{dir -30}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

p:=p+1;
clearxy;
z0=(0, 0.1s);
z1=(x0 + r*sw, 0.9s);
paths[p] = z0{dir 55}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


endglyph;
