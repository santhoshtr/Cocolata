input glyph;
beginglyph;
z0= (x1 + mw/2, 0.9m);
z1 = (0, 3/4m);
z2 = ((x0+x1)/2.5,1/2m);
z3 = (x0, 1/4m);
z4 = ( x2, 0);
z5 = ( x1, 0.3m);
z6 = ( x3+0.1sw, 0.8m);

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
