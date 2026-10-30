input glyph;
beginglyph;
z0= (x1 + 0.59mw, 0.85X);
z1 = (0, 1.23m);
z2 = ((x0+x1)/2.5, 0.71m);
z3 = (x0, 0.3m);
z4 = ( x2, 0);
z5 = ( x1, 0.39m);
z6 = ( x3+0.12sw, 0.95m);

paths[p]:=z0{dir 120}...{dir 235}z1..z2{dir -24}..z3..z4..z5{dir 50}..{dir 20}z6;
paths[p]:=harmonize(paths[p]);

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib rotated 30)(2)
    nib(thicknib)(3)
    nib(thicknib)(4,5,6)
)(paths[p])(strokes[p]);

endglyph;
