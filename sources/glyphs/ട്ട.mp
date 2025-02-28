input glyph;
beginglyph;

z0= (x1 + mw/2, m);
z1 = (0,3/4m);
z2 = ((x0+x1)/2.5,1/2m);
z3 = (x0, 1/4m);
z4 = ( x1+ thick/2, undershoot);
z5 = ( x3 + thick/2, -m/4);
z6 = ( x1 - thick/2, -m/2);

paths[p]:=z0..{dir 220}z1..z2{dir -30}..z3..{dir 170}z4{right}..z5{dir -45}..{dir 170}z6 ;
paths[p]:=harmonize(paths[p]);

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib rotated 30)(2)
    nib(thicknib)(3,4,5,6)
)(paths[p])(strokes[p]);

anchor("vc", point 0.5 of paths[p]);
anchor("right", point 5.5 of paths[p]);

endglyph;
