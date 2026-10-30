input glyph;
beginglyph;
z0 = (0, X);
z1 = (x0+ 0.1sw, y0 + 0.2X);
paths[0] = z0-- z1;
pen_stroke(
    nib(thinnib)(0)
    nib(thicknib)(infinity)
)(paths[0])(strokes[0]);

paths[1] := paths[0] shifted(sw/4, 0);

pen_stroke(
    nib(thinnib)(0)
    nib(thicknib)(infinity)
)(paths[1])(strokes[1]);

anchor( "top", ((xpart(point 1 of paths[0]) + xpart(point 1 of paths[1]))/2 , X));
endglyph;
