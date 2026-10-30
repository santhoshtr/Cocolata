input glyph;
beginglyph;
z0 = (0.5sw, s/2);
z1 = (x0 - 0.5sw, y0 + s/4);
z2 = (x0 - 0.5sw, y0 - s/4);
paths[0] = z0--z1;
paths[1] = z0--z2;
pen_stroke(
    nib(thicknib)(0, infinity)
)(paths[0])(strokes[0]);
pen_stroke(
    nib(thicknib)(0, infinity)
)(paths[1])(strokes[1]);
endglyph;
