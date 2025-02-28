input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + mw/4 , y3);
z5 = ( x4  , m);


paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{right}z4   ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib )(3)
    nib(thicknib)(4)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
input ./glyphs/include/മ;
xshift := xpart point infinity of paths[p-1];
yshift :=  ypart point infinity of paths[p-1];;
paths[p] := paths[p] shifted (xshift , yshift);
strokes[p] := strokes[p] shifted (xshift , yshift);

anchor( "vc", point 0.5 of paths[1]);

anchor( "right", (xpart point 4 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
