input glyph;
beginglyph;
z0 = (thick/2, y1 + s/3);
z1 = (x0+ 0.25sw, X);
paths[0] = z0--z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thinnib)(1)
)(paths[0])(strokes[0]);
z2 = (x1 + 0.25sw, y0);
paths[1] =z1--z2;
pen_stroke(
    nib(thinnib)(0)
    nib(thicknib)(1)
)(paths[1])(strokes[1]);
anchor( "top", (xpart(point 1 of paths[0]), X));
endglyph;
