input glyph;
beginglyph;
z0 = (x2 + 2/3Xw, 0.4X);
z1 = ((x0+x2)/2.5, undershoot);
z2 = (0, (y1+y3)/2);
z3 = (0.8x1, 0.5X);
z4 = (0.85x0, 0.75X);
z5 = (x1, X);
z6 = (0.25x1, y4);
z7 = (x0, 0);
paths[p] = z0..z1{left}..z2{up}..z3..{up}z4..z5..{dir -60}z6..{dir -45}z7;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7)
)(paths[p])(strokes[p]);

endglyph;
