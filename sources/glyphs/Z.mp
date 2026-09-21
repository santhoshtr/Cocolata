input glyph;
beginglyph;
z0 = (0, 0.95X);
z1 = (0.65Xw, X);
z2 = (x0, 0);
z3 = (x1, 0);


paths[p] =  z0{right}..z1--z2{dir 10}..z3 ;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0.5 of paths[0]), 1.1X));
endglyph;
