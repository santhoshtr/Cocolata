input glyph;
beginglyph;

z0 = (0 , m-overshoot);
z1 = (x0 + 0.8mw, 0.6m);
z2 = ((x1 +x3)/2, y0);
z3 = (x1 - mw/2, 0.66m);
z4 = (x3+0.15mw , 0.2m);
z5 = (x3-0.2mw , -0.05m);


paths[p] = z0{dir -120} ..{dir 45}z1 ..z2..z3  ..z4..z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
  nib(thicknib  )(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);

anchor( "vc", (x4,0));
anchor( "right", point 4.75 of paths[p] );

endglyph;

