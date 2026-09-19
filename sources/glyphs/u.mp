input glyph;
beginglyph;
z0 = (0, 0.9s);
z1 = (0.35(x0 + x2), undershoot);
z2 = (0.6sw, y0);
z3 = (x2  + 0.1sw, 0);

paths[p] =  z0{dir -100} ..z1...{dir 80}z2{dir -100}.. z3 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1.2 of paths[0]), 1.2s));
endglyph;
