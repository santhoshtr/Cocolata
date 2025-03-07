input glyph;
beginglyph;

clearxy;

z0= (thick, 0.75m);
z1= (x0 + mw/6, 0.6m);
z2 = (x0 + mw/3, y0);
z3 = ( x1, m);
z4 = (0, m/2);
z5 = (x4 + mw/4, 0);
z6 = (x5 + mw/3, 0.2m);
z7 = (x4, m/3);
paths[p]:=z0{dir -60}..{dir 90}z2..{left}z3..z4..z5..z6..{dir 215}z7  ;
paths[p]:=harmonize(paths[p]);

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib )(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib scaled 0.9 rotated -30)(7)
)(paths[p])(strokes[p]);

endglyph;
