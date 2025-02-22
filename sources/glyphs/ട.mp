input glyph;
beginglyph;

z0= (x1 + mw/2, m);
z1 = (0, 0.66m);
z2 = (x0, 0.2m);
z3 = ( x1 - thick/2, 0);

paths[p]:=z0{left}..z1..z2{down}..{dir 170}z3 ;
paths[p]:=harmonize(paths[p]);

pen_stroke(
    nib(thicknib rotated -30)(0)
    nib(thicknib rotated 30)(1)
    nib(thicknib rotated 30)(2)
    nib(thicknib)(3)
    nib(thicknib rotated -30)(4)
)(paths[p])(strokes[p]);

anchor("vc", point 0.5 of paths[p]);
anchor("right", (xpart(point 2.5 of paths[p]), ypart(point 2.5 of paths[0])));

endglyph;
