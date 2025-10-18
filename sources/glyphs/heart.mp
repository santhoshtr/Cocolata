input glyph;
beginglyph;

z0 = ( 0.6sw, 0.6s);
z1 = (x0 + mw/4, s);
z2 = (x1 + mw/4, 0.5s);
z3 = (x0+ 0.1mw, 0);
z4 = (x0 - mw/2, y2);
z5 = (x4 + mw/4, y1);
z6 = (x0, y0);

paths[p] = z0{dir 80} ..z1 ..z2..{dir 225}z3{dir 155}..z4..z5..{dir -80}z6;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5,6 )
)(paths[p])(strokes[p]);

endglyph
