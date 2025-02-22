input glyph;
beginglyph;


z0= (0,undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 +  0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/6 , 0); % bottom middle
z5 = ( x3 + mw/2, 0);
z6 = ( x5,1.1m);

paths[p]:=z0 ..z1..z2{right}..z3..{left}z4{right}..{right}z5{dir 100}..{dir 80}z6  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib scaled 1.2)(0)
    nib(thicknib )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.2)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib scaled 1.2 rotated 0)(6)
)(paths[p])(strokes[p]);


anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "bottom", (xpart(point 5 of paths[0]),0));
anchor( "right", (xpart point 5 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift) );

endglyph;
