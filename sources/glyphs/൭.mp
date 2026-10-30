input glyph;
beginglyph;

z0=(x3 + thick*0.15, y3);
z1=(x0 + mw/2, y3 - m/4);
z2=(x1 - mw/5, overshoot);
z3=(0, m/2);
z4=(x3 + mw/2, m);
z5=(x4 + mw/2, m/2);
z6 = (x2, -descent);

paths[0] = z0..z1{down}..z2{left}..z3..z4..{down}z5..z6;

pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4, 5, 7)
)(paths[p])(strokes[p]);

endglyph;
