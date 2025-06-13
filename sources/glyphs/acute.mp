input glyph;
beginglyph;
z0 = (0, 0.9X);
z1 = (x0+ 0.1sw, y0 + 0.25X);
paths[p] = z0-- z1;
pen_stroke(
    nib(thinnib )(0)
    nib(thicknib)(1)
)(paths[p])(strokes[p]);
anchor( "top", (xpart(point 1 of paths[0]), X));
endglyph;
