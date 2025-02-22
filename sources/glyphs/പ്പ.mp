input glyph;
beginglyph;

input ./glyphs/include/പ;

clearxy;
p:=p+1;
z0 = (xpart point 1 of paths[p-1], 0.68m);
z1 =  point  4.5 of paths[p-1];

paths[p] := z0{dir 60} .. {dir 0}z1;
z2 =  point 0.5 of paths [p];
paths[p] := z0{dir 45} ..z2.. {right}z1;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib rotated 30 )(2)
)(paths[p])(strokes[p]);
anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "bottom", point 4 of paths[1]);
anchor( "right", (point 4 of paths[0] - (u_drop_sign_radius, 0)));

endglyph;
