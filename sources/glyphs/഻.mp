input glyph;
beginglyph;
z0 =(0, y1 + .4m);
z1 =(0, m*1.1);
paths[0] = z0{dir -80}..z1;
pen_stroke(
    nib(thicknib)(0,1 )
)(paths[0])(strokes[0]);
paths[0] := paths[0] shifted (-x1, 0);
endglyph;
