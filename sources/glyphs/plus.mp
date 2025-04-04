input glyph;
beginglyph;
paths[0] = (0, s/2){dir 5}..(0.75sw, s/2);
paths[1] := paths[0] crotated 85;
pen_stroke(
    nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

pen_stroke(
  nib(thicknib)(0,1)
)(paths[1])(strokes[1]);
endglyph;
