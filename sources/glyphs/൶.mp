input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..{left}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 2/3mw , y3);

paths[p]:=z3--z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
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
