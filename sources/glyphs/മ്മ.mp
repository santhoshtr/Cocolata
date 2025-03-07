input glyph;
beginglyph;
clearxy;

clearxy;

z0= (x3 , m/2);
z1= (x0+mw/4, m-overshoot);
z2 = (x1+mw/3, y0);
z3 = ( 0, 0);
z4 = ( x2 + mw/4 , y3);
z5 = ( x2+thick/2, y0);
z6 = ( x5+mw/4, y1);
z7 = ( x6+mw/3, y2);
z8 = ( x2, y3);
z9 = ( x7 + mw/4, y8);
z10 = ( x7 + thick/2, y5);


paths[p]:=z0{dir 90}..z1..{dir 240}z2..{left}z3{right}..{right}z4{dir 120}
..{up}z5..z6..{dir 240}z7..{left}z8{right}..{right}z9{dir 120}..{up}z10;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5,6,7,8,9,10)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 4 of paths[0]),0));
anchor( "bottom", point 9 of paths[0]);
anchor( "right", (xpart point 9 of paths[0] - u_drop_sign_radius,u_drop_sign_vshift) );
endglyph;
