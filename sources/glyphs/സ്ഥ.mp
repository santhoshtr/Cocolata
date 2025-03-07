input glyph;
beginglyph;

input ./glyphs/include/സ;

p:=p+1;
clearxy;
z0 = (0 , 0.1m);
z1 = (x0 + mw/2, undershoot);
z2 = (x0 + mw, 0.5m);
z4 = (x2 - mw/4, 0.9m);
z5 = (x4 - mw/3 , 0.2m);

paths[p] = z0.. z1  ..z2..z4..{dir 285}z5;
paths[p]:=harmonize(paths[p]);
paths[p]:= paths[p] shifted (xpart point infinity of paths[p-1] + mw/4 , 0);
pen_stroke(
    nib(thicknib )(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart( point 3 of paths[0]),0));
anchor( "right", (xpart point 1 of paths[p],u_drop_sign_vshift));

endglyph;
