input glyph;
beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
paths[0] = (0, 0)--(0.75sw, 0);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(infinity)
)(paths[0])(strokes[0]);

endglyph;
