clearxy;

z0 = (0.25mw, 0.6m);
z1 = (x0 +  0.2mw, y0 + 0.2m);
z2 = (x1 -  0.2mw, y1 + 0.2m);
z3 = (x2 -  0.2mw, y2 - m/4);
z4 = (x3 + mw/2, y3 - m/3);
z5 = (x4 + mw/2, y4 - m/3);
z6 = (x5 - mw/2, y5 - m/3);
z7 = (x6 - mw/3, y6 + m/3);
z8 = (x7 + mw/2, y7 + m/3);
z9 = (x8 + mw/2, y8 + m/3);
z10 = (x9 -  0.2mw, y2);
z11 = (x10 - 0.2mw, y10 - 0.2m);
z12 = (x11 + 0.2mw, y11 - 0.2m);
paths[p] = z0  .. z1..z2..z3..z4..z5
    ..{left}z6..z7..z8..z9..z10..z11
    ..z12 ;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib)( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
)(paths[p])(strokes[p]);