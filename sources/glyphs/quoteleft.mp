input glyph;
beginglyph;

clearxy;
z0=(0, X);
z1=(x0 + 0.1s, y0-0.3s);
paths[p] = z0{down}..z1;
pen_stroke(
   nib(thicknib)(0)
   nib(thicknib)(1)
)(paths[p])(strokes[p]);

endglyph;
