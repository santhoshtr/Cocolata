input glyph;
beginglyph;
z0 = (0, X-overshoot);
z1 = (x0 + 0.67Xw, y0);
z2 = (x0, undershoot);
z3 = (x1, y2);


paths[p] =  z0{dir -10} ...{dir 10}z1{dir 250}...{dir 250}z2{dir 10}..{dir -10}z3  ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.2s));
endglyph;
