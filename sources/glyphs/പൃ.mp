input glyph;
beginglyph;

input ./glyphs/include/പ;
p:=p+1;
clearxy;
paths[p] = vocalic_r_sign shifted (xpart point infinity of paths[p-1], 0);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 2 of paths[0]),0));

endglyph;
