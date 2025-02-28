input glyph;
beginglyph;

z0 = (x1 +  thick/4 , m-overshoot);
z1 = (0, (y0 + y2)/2.1);
z2 = ((x1 + x3)/2.5, 0.3m);
z3 = (x1 + mw, (y2 + y4)/1.9);
z4 = ((x3 + x5)/2, m-overshoot);
z5 = (x4 - mw/3.5, y4 - .25m);
z6 = (x5 + mw/6, y7 + 0.25m);
z7 = ((x5+x7)/2.5, -2undershoot);
z8 = (x6 - mw/2, y7+ 0.15m);
paths[p] = z0 ..z1..z2 ..z3 ..z4{dir 160} ..z5 ..z6..z7{dir 160}..z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
  nib(thicknib  )(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);

anchor( "vc", (x4,0));
anchor( "right", point 6.5 of paths[p] );

endglyph;

