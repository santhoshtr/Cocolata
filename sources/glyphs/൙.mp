input glyph;
beginglyph;
z0=(x1 + mw/4, undershoot);
z1=(0, (y0 + y2)/2.2);
z2=(x1 + mw/2, m-overshoot);
z3=(x2 + mw/2, (y2+y4)/2.5);
z4=(x3 - mw/3, undershoot);
z5=(x4 - mw/4, (y4+y6)/2);
z6=(x4 + mw/2, y4 + m/2);
z7=(x6 + 0.6mw, (y6 + y8)/2);
z8=(x7 - mw/4, m-overshoot);
z9=(x8 - mw/4, m/2);

paths[p] = z0..z1{up}..z2{right}..z3{down}..z4..{dir 90}z5..{dir -20}z6..z7{up}..{left}z8..z9;

pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
)(paths[p])(strokes[p]);

endglyph;
