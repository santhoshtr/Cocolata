input glyph;
beginglyph;

clearxy;
z0=(0, 0.1s);
z1=(x0 - 0.1s, y0-0.3s);
paths[p] = z0{down}..z1;
pen_stroke(
   nib(thicknib)(0)
   nib(thicknib rotated 30)(1)
)(paths[p])(strokes[p]);

anchor( "bottom", point 0 of paths[0]);
endglyph;
