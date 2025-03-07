input glyph;
beginglyph;
z0=(mw/2, 0.65m);
z1=((x0 + x2)/2.25, 0.9m);
z2=(x0 + 0.6mw, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(x0, m/3);
z5=(x4-mw/4, y3);
z6=(x5-mw/4, 0.3m);
z7=(x2, y2);
z8=(x7+mw/4, y6);
z9=(x2 + mw/4, undershoot);
z10 = ( x9 + 0.9mw , y9);
z11 = ( x10 - 0.6mw, 0.7m);
z12 = ( (x11+x13)/2  , 0.95m);
z13 = ( x10   , 0.7m);
z14 = ((x9+x10)/2 , 0.1m);

paths[p] := z0 ..{right}z1..{down}z2..z3{left}..{up}z4{down}
    ..z5{left}..{dir 60}z6.. z7..{left}z9{right}
    ..{right}z10{dir 120}
    ..z11..z12..z13..{dir -80}z14;
paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11,12)
)(paths[p])(strokes[p]);


anchor( "vc", point 1 of paths[p]);
anchor( "right", (xpart(point 10 of paths[p]) - u_drop_sign_radius,0));

endglyph;
