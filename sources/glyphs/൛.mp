input glyph;
beginglyph;
z0=(0, 0);
z1=(x0, m);
z2=(x0 + 0.65mw , y1);

paths[0] = z0..{dir 100}z1{dir -10}..z2;
pen_stroke(
    nib(thicknib)(0, 1,2)
)(paths[0])( strokes[0]);


clearxy;
z0 = point infinity of paths[0];
z1 = (x0 - mw/3, y0-m/2);
z2 = ((x1 + x3)/2, 0);
z3 = (x1 + .9mw, y1);
z4 = (x3 - mw/6, 0.9m);
paths[2] = z0..z1{down}..z2..z3{up}..z4;
pen_stroke(
    nib(thicknib)(0, 1,2,3,4)
)(paths[2])( strokes[2]);
endglyph;
