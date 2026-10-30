input glyph;
beginglyph;
paths[0] = (0, s/2)--(0.75sw, s/2);
paths[1] = paths[0] shifted(0, s/3);
pen_stroke(
    nib(thicknib)(0, infinity)
)(paths[0])(strokes[0]);
pen_stroke(
    nib(thicknib)(0, infinity)
)(paths[1])(strokes[1]);
endglyph;
