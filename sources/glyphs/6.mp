input glyph;
beginglyph;
z0 = (x1+0.3sw, s);
z1 = (0, s/2);
z2 = (x1 + sw/4, undershoot);
z3 = (x2 + sw/4, s/4);
z4 = (x1, s/2);
paths[0] = z0..z1..z2{dir 5}..z3..{left}z4;
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

endglyph;
