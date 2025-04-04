input glyph;
beginglyph;
soften:=0;
% This glyph does not slant. Reset slant value
slant := 0;
r = thick*1.66;

paths[p] = circle(r) xscaled 0.8 shifted(-r/2, .6s);
strokes[p] = paths[p];
clearxy;

p:=p+1;
z0=(0, 0.3s);
z1=(x0 - 0.1s, y0-0.3s);
paths[p] = z0{down}..z1;
pen_stroke(
   nib(thicknib)(0)
   nib(thicknib rotated 30)(1)
)(paths[p])(strokes[p]);


endglyph;
