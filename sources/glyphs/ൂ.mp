input glyph;
beginglyph;
z0=(mw/12, m-overshoot);
z1=(x0 + mw/4, (y0+y2)/2);
z2=(x1 - 0.1mw, 0);
paths[0] = z0 ..z1{down}..z2;
pen_stroke(
   nib(middle_down_nib rotated terminalangle 0 of paths[p])(0)
   nib(down_nib rotated 90 )(1)
   nib(end_nib rotated terminalangle 2 of paths[p])(2)

)(paths[0])(strokes[0]);

clearxy;
p:=p+1;
r=u_drop_sign_radius;
z0=(0, (y1 + y3)/2);
z1=((x2+x0)/2, 0);
z2=(x1 + r, y0);
z3=(x1, -descent);
z4=(x0, y0);

paths[p] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
paths[p]:= paths[p] shifted (0, -y1);
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(middle_up_nib scaled 0.8)(0,4)
   nib(middle_down_nib scaled 0.8)(2)
   nib(top_nib scaled 0.8)(1)
   nib(down_nib scaled 0.8)(3)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=point 0.3 of paths[p-1];
z1=(xpart(point 1 of paths[p-1]), ypart(point 2.1 of paths[p-1]));
z2=point 1.7 of paths[p-1];
paths[p] = z0{down}..z1..{up}z2;

pen_stroke(
   cut(thinnib, rel 90)(0)
   nib(thinnib)(1)
   cut(thinnib, rel 90)(2)
)(paths[p])(strokes[p]);

absolute_position := 1;
lbearing:=lbearing/2;
rbearing:=rbearing/2;
endglyph;
