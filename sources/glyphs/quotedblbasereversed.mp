input glyph;
beginglyph;

z0=(0, m/6);
z1=(x0 - 0.05s, y0-0.3s);
paths[p] = z0{down}..z1;
pen_stroke(
   nib(thicknib)(0)
   nib(thicknib rotated 30)(1)
)(paths[p])(strokes[p]);

paths[1] := paths[0] shifted(sw/4, 0);
strokes[1] := strokes[0] shifted(sw/4, 0);
endglyph;
