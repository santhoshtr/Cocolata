input glyph;
beginglyph;
clearxy;
z0=(0.6mw, 0.65m);
z1=((x0 + x2)/2.25, m-overshoot);
z2=(x0 + 0.5mw, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(x0, m/3);
z5=(x4-mw/4, y3);
z6=(x5-mw/4, 0.3m);
z7=(x1, 0.65m);
z8=(x2 + mw/2, 4undershoot);
z9=(x2, y4);
z10=(x8, 0.9m);
z11=(x8+mw/3, 0);
z12=(x0, -m/2);
z13=(0, 0.9m);
paths[p] := z0 ..{right}z1..{down}z2..z3{left}..{up}z4{down}
    ..z5{left}..{dir 60}z6.. z7..z8 .. {up}z9..z10..{dir 230}z11
    ..z12{left}..{dir 60}z13;
paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11)
nib(thicknib rotated -30)(12)
   nib(thicknib)(13)
)(paths[p])(strokes[p]);


anchor( "vc", point 1 of paths[0]);
anchor( "right", point 11.25 of paths[p]);

endglyph;
