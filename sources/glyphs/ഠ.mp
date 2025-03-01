input glyph;
beginglyph;

z0=((x1+x3)/2, m-overshoot);
z1=(0,(y0+y2)/2);
z2=(x0,undershoot);
z3=(x1+ 0.8mw, y1 );
z4=z0;

paths[0] = z0..z1..z2..z3..z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2, 3)
)(paths[0])(strokes[0]);

anchor( "vc", (xpart(point 1 of paths[0]),0));
anchor( "bottom", (xpart(point 2.75 of paths[0]),0));
anchor( "right", (xpart(point 2.75 of paths[0]),0));
endglyph;
