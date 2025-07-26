input glyph;
beginglyph;
z0 = (0, 0.9X);
z1 = (0.5(x0 + x2), undershoot);
z2 = (0.5Xw, s);
z3 = (0.5(x2 + x4), undershoot);
z4 = (x2  + 0.5Xw, y0);

paths[p] =  z0{dir -90} ...z1...{dir 80}z2{dir -80}...z3...{dir 80}z4 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
