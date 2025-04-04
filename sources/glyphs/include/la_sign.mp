clearxy;

z0 =(x2 + 0.1mw, 0.4y1);
z1=(x0 + 0.4mw - mw/4, -descent+undershoot);
z2=(0, y0);
z3=(x2 + mw/3, -undershoot);
z4=(x3 + mw/4, (y3+y5)/2);
z5=(x4 + mw/4, y1);
z6=(x5 + mw/4, -undershoot);

paths[p] = z0{right} ...z1..z2...z3 ... z4{dir 280}...z5 ...{dir 80}z6;
paths[p] := harmonize(paths[p]);
pen_stroke(
   nib(thicknib  )(0,1,2,3,4,5,6)
)(paths[p])(strokes[p]);