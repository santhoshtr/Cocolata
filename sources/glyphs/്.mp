input glyph;
beginglyph;

z0 = (0, m + m/3+thick/2);
z1=(x0 + 0.3mw, y0 - m/3);
z2=(x1 + 0.3mw, y1 + m/3);

paths[p] = z0 .. {dir -10}z1.. z2;
paths[p] := paths[p] shifted (-x1, 0);

pen_stroke(
     nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);

absolute_position := 1;
lbearing:= 0;
rbearing:= (xpart point 1 of strokes[p]) - (xpart point 2 of strokes[p]);

endglyph;
