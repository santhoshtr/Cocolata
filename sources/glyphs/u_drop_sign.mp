input glyph;
beginglyph;
r=u_drop_sign_radius;
z0=(0, (y1 + y3)/2);
z1=((x2+x0)/2.5, 0);
z2=(x1 + r, y0);
z3=(x1, y0-r);
z4=(x0, y0);

paths[p] = z1 ..z0..z3..z2..{dir 170}z1 ;
paths[p]:= paths[p] shifted (0, -y1);
paths[p]:= harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0)
   nib(thicknib)(1)
   nib(thicknib)(2)
   nib(thicknib)(3)
)(paths[p])(strokes[p]);

anchor("right", point 0 of paths[0] );

endglyph;
