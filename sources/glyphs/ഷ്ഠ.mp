input glyph;
beginglyph;

input ./glyphs/include/ഷ.mp;

clearxy;
p:=p+1;

z0=((x1+x3)/2, m-overshoot);
z1=(0,(y0+y2)/2);
z2=(x0,undershoot);
z3=(x1+ 0.8mw, y1 );
z4=z0;

paths[p] = z0..z1..z2..z3..z4;
paths[p] := paths[p] shifted(0.85mw, -1.1m) xscaled 0.75 yscaled 0.7;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib scaled 0.9)(0,1,2, 3)
)(paths[p])(strokes[p]);

anchor( "vc", point 0.5 of paths[1]);

anchor( "right", (xpart(point 1 of paths[1]) - u_drop_sign_radius,0));

endglyph;
