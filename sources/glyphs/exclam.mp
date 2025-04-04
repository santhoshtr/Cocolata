input glyph;
beginglyph;
z0= (0, 0.9X);
z1=( x0, y0 - 0.7X);

paths[0] = z0{dir -80}..z1;
pen_stroke(
    nib(thicknib scaled 1.2 )(0,1)
    nib(thicknib scaled 0.8 )(1)
)(paths[0])(strokes[0]);

paths[1] = fullcircle scaled (thick*1.5) yscaled 0.8 rotated -30 shifted(0, 0);
strokes[1] = paths[1];

endglyph;
