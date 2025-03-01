input glyph;
beginglyph;
save r,e;
r=0.7;
z0 = (r*Xw, y1-.2X);
z1 = ((x0 + x2)/1.8, 0.9X);
z2 = (0, (y1+y3)/2);
z3 = ((x0 + x2)/2, undershoot);
z4 = (x0, 0.15X);
paths[p]:=z0..z1..z2{dir 260} ..z3 ..z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0,1,2, 3,4)
)(paths[0])(strokes[0]);


lbearing:=sw/3*0.3;
rbearing:=sw/3*0.3;
anchor( "top", (xpart(point 1 of paths[0]), 1.2s));
endglyph;
