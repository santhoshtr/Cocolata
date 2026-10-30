input glyph;
beginglyph;

z0 = (x1 + 0.71sw, 0.95X);
z1 = (0, 0.55(y0+y2));
z2 = (0.35(x1 + x3), 0.65s);
z3 = (x0 + 0.06sw, 1.19s);
z4 = (x3  - 0.12sw, 0);

paths[p] = z0{dir 170} ..z1 ..z2...{dir 80}z3{dir -90}...{dir -100}z4;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);


endglyph;
