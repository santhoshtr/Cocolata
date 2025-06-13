input glyph;
beginglyph;
z0 = (0, X-overshoot);
z1 = (x0 + 0.67Xw, 0.8(y0+y4));
z2 = ((x1 + x3)/2, (y0+y4)/2);
z3 = (x0, 0.2(y0+y4));
z4 = (x1, undershoot);


paths[p] =  z0{dir 0} ...z1...{dir 220}z2...z3...{dir 0}z4  ;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0.5 of paths[0]), 1.1X));
endglyph;
