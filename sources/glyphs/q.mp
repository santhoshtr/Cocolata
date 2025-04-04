input glyph;
beginglyph;

z0 = (x1 + 0.6sw, 0.9s);
z1 = (0, 0.55(y0+y2));
z2 = (0.35(x1 + x3), undershoot);
z3 = (x0 + 0.05sw, 0.6s);
z4 = (x3  - 0.1sw, -descent);
z5 = (x4  + 0.2sw, -0.75descent);
paths[p] = z0{dir 180}..z1 ..z2...{dir 80}z3{dir -100}...{dir -80}z4{dir 45}...z5;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
    nib(thicknib scaled 0.8)(5 )
)(paths[p])(strokes[p]);

rbearing:=-0.1sw;

anchor( "top", (xpart(point 0 of paths[0]), 1.2s));
endglyph;
