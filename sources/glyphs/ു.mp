input glyph;
beginglyph;
z0=(mw/12, m-overshoot);
z1=(x0 + mw/4, (y0+y2)/2);
z2=(x1 - 0.1mw, 0);
paths[0] = z0 ..z1{down}..z2;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0,1,2,3,4)
)(paths[0])(strokes[0]);

clearxy;
p:=p+1;
z0=(x1-mw/4, (y1 + y3)/2);
z1=(xpart point infinity of paths[0], 0);
z2=(x1 + mw/4, y0);
z3=(x1, -0.66descent);
z4=(x0, y0);

paths[p] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

absolute_position := 1;
lbearing:=lbearing/2;
rbearing:=rbearing/2;
endglyph;
