input glyph;
beginglyph;
z0 = (0, 0.5s);
z1 = (x2 + 0.6sw, 0.9s);
z2 = (0, 0.5(y1+y3));
z3 = (x1 + 0.05sw, 0.1s);
paths[p] = z0{dir -30}..z1 ...z2{dir -95}...z3;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0 of paths[0]), 1.2s));
endglyph;
