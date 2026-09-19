input glyph;
beginglyph;
paths[0] = (0, X)--(sw/2, X);

pen_stroke(
    nib(thicknib)(0, 1)
)(paths[0])(strokes[0]);
anchor( "top", (sw/4, X));
endglyph;
