input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..{dir 200}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 0.75mw , y3);
z5 = ( x4 - mw/4, 0.8m);
z6 = ( (x3+x4)/2, 0.2m);

paths[p]:=z3{right}..{dir -0}z4{dir 10}..z5{left}..{dir 290}z6  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib )(2)
    nib(thicknib )(3,4,5,6)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "bottom", (xpart(point 0 of paths[p]),0));
anchor( "right", (xpart point 4 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift) );

endglyph;
