input glyph;
beginglyph;
z0 = (0, 0.0);
z1 = (x0, 0.95X);
z2 = (0.4Xw, 0.4X);
z3 = (x2 + 0.4Xw, y1);
z4 = (x3, 0);

paths[p] =  z0{dir 80} ..{dir 100} z1{dir -60}...{dir -40}z2{dir 45}...{dir 60}z3{dir -80}..z4 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);



anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
