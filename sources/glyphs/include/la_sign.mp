clearxy;

z0 =(x4 + mw/4, (y1 + y3)/1.5);
z1 =(x0 + mw/6, y3+0.55m);
z2=(x1 + mw/4, y0);
z3=(x2 - mw/4, thick*0.6/2);
z4=(0, y0);
z5=(x4 + mw/2, m-overshoot);
z6=(x5 + mw/2, (y5+y7)/2);
z7=(x6 + mw/3, y3);
z8=(x7 + mw/4, (y7+y9)/2);
z9=(x8 - mw/6, m);

paths[p] = z0 ..z1..z2..z3..z4..z5 .. z6..z7 ..z8..z9;
paths[p] := harmonize(paths[p]);
paths[p] := paths[p] shifted(0,-m*1.1) xscaled 0.8 yscaled 2/3;
pen_stroke(
   nib(thicknib  )(0,1,2,3,4,5,6,7,8,9)
)(paths[p])(strokes[p]);