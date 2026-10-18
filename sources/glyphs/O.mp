input glyph;
beginglyph;
z0=((x1+x3)/2, X );
z1=(0,(y0+y2)/2);
z2=(x0,undershoot);
z3=(x1+ 0.75Xw, y1 );
z4=(x0,0.9X);

paths[0] = z0..z1..z2..z3..{left}z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2, 3)
)(paths[0])(strokes[0]);


lbearing:=sw/3*0.4;
rbearing:=sw/3*0.4;
anchor( "top", (xpart(point 0 of paths[0]), 1.1X));
endglyph;
