input glyph;
beginglyph;

z0 = (x1 + mw/8, m);
z1 = ( 0, (y0+y2)/2);
z2 = ( x1 + mw/2 , -m/3);
paths[0] = z0..z1..{right}z2;
pen_stroke(
    nib(thicknib)(0, 1, 2)
    ignore_directions(1)
)(paths[0])(strokes[0]);

rbearing:=-4rbearing;

endglyph;
