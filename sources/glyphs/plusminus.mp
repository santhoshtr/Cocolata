input glyph;
beginglyph;
paths[0] = (0, 0.6s){dir 5}..(0.75sw, 0.6s);
paths[1] := paths[0] crotated 85;
pen_stroke(
    nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

pen_stroke(
  nib(thicknib)(0,1)
)(paths[1])(strokes[1]);

paths[2] := paths[0] shifted(0, -s/2);
pen_stroke(
    nib(thicknib)(0,1)
)(paths[2])(strokes[2]);

endglyph;
