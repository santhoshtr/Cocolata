input glyph;
beginglyph;

input ./glyphs/include/വ;


p:=p+1;
clearxy;
paths[p] = vocalic_r_sign shifted (xpart point 4 of paths[p-1], 0);
pen_stroke(
    nib(thicknib  )(0)
    nib(thicknib )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.2)(3)
    nib(thicknib)(4)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 2 of paths[0]),0));

endglyph;
