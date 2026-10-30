input glyph;
beginglyph;
z0 = (0, 0.4s);
z1 =  (z0 +z2)/2;
z2 = (sw, 0.6s);
paths[0] = z0{dir 60}..{dir -30}z1..{dir 60}z2;
pen_stroke(
    nib(thicknib)(0, 1, infinity)
)(paths[0])(strokes[0]);
endglyph;
