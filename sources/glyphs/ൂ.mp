input glyph;
beginglyph;
r=u_drop_sign_radius;

z0=(0, 0.9m);
z1=(x0 + mw/4, (y0+y2)/2);
z2=(x1 - 0.1mw, 0);
z3=(x2+r, y2 - r);
z4=(x2, y3-r);
z5=(x2-r,y3);
z6=z2+(0.05mw, 0.05m);
z7 = (x3, y4 - 0.1m);
paths[0] = z0 ..z1{down}..{dir 250}z2{right}..z3..z4..z5..{right}z6..{left}z7;

paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0,1,2,3,4,5,6,7)
)(paths[0])(strokes[0]);

absolute_position := 1;
lbearing:=lbearing/2;
rbearing:=0;
endglyph;

