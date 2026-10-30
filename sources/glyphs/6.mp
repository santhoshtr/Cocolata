input glyph;
beginglyph;
z0 = (x1+0.36sw, 0.95X);
z1 = (0, 0.59s);
z2 = (x1 + 0.3sw, undershoot);
z3 = (x2 + 0.3sw, 0.4s);
z4 = (x1, 0.71s);
paths[0] = z0..z1..z2{dir 5}..z3..{left}z4;
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

endglyph;
