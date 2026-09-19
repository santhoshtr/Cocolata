input glyph;
beginglyph;
z0 = (0, 0.6s);
z1 = (0.75sw, y0);
z2 = (x1, y1- s/3);
paths[0] = z0--z1--z2;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1,2)
)(paths[0])(strokes[0]);

endglyph;
