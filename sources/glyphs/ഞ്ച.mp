input glyph;
beginglyph;

input ./glyphs/include/left_arch_with_eye;

clearxy;
p:=p+1;
z0= point 6.5 of paths[p-1];
z1= (x0 + mw/3,  0.95m); % top
z2 = ( x1 + mw/2, 0.5m);
z3 = ( (x2 + x4)/2,  0.25m);
z4 = ( x0 + 0.3mw,  0.5m);
z5 = ( (x4 + x6)/2,  0.75m);
z6 = ( x2 + mw/4 ,  m/3);
z7 = ( x1 ,  0);
z8 = ( x6 + mw/3,  y7);
z9 = ( x8, 1.2m);

paths[p] := z0{up}..z1..z2..z3..z4{up}..z5..z6{down}
    ..{left}z7{right}..{right}z8{dir 100}..z9;

paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 4 of paths[1]),0));
anchor( "right", (xpart(point 8 of paths[1])-u_drop_sign_radius,0));

endglyph;
