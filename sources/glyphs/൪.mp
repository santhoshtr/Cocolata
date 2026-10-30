input glyph;
beginglyph;
z0=(x1 + mw/4, 0);
z1=(0, y0 + m/2);
z2=(x1 + mw/2, m-overshoot);
z3=(x2 + mw/1.75, (y2+y4)/2.4);
z4=(x3 - mw/3, undershoot);
z5= (x4 - mw/4, (y4 + y6)/3);
z6= (x4, ascent);
paths[0] = z0..z1{up}..z2{right}..z3{down}..z4..z5{up}..{up}z6;
paths[0] := paths[0] ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6)
)(paths[0])(strokes[0]);

endglyph;
