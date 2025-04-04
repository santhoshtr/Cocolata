input glyph;
beginglyph;
z0 = (0, 0.9s);
z1 = (0.5(x0 + x2), undershoot);
z2 = (0.6sw, 0.6s);
z3 = (0.5(x2 + x4), y1);
z4 = (x2  + 0.6sw, y0);

paths[p] =  z0{dir -80} ...z1...{dir 80}z2{dir -80}... z3...{dir 85}z4 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.2s));
endglyph;
