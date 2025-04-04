input glyph;
beginglyph;
z0 = (0, 0.0);
z1 = (x0, 0.95X);
z2 = (0.6Xw, y0);
z3 = (x2, y1);

paths[p] =  z0{dir 80} ..{dir 100} z1{dir -60}...{dir -40}z2{dir 80}...{dir 100}z3 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);



anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
