clearxy;
z0=(x1 + mw/6, 0.9m);
z1=(0, y0 - m/2);
z2=((x1+x3)/2, undershoot);
z3=(x2 +  mw/3, 0.8m);
paths[p] = z0..z1 ..z2  ..{up}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);