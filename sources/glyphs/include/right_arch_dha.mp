
clearxy;
z0= point infinity of paths[p-1];
z1=((x0 + x2)/2, undershoot);
z2=(x0 +  0.7mw, y1 + m/2);
z3=(x2 -  mw/6, 0.95m);
paths[p]:= z0{down}..z1..z2 ..z3;
paths[p]:=harmonize(paths[p]);

pen_stroke(
 nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);
