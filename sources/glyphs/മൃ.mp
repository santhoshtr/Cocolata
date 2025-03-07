input glyph;
beginglyph;
input ./glyphs/include/മ;

p:=p+1;
clearxy;
paths[p] = vocalic_r_sign shifted (xpart point 4 of paths[0], 0);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 1 of paths[0]),0));
anchor( "bottom", point 4 of paths[1]);
anchor( "right",  point 4 of paths[1]);

endglyph;
