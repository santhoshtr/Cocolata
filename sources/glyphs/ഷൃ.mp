input glyph;
beginglyph;

input ./glyphs/include/ഷ.mp;

p:=p+1;

paths[p] = vocalic_r_sign shifted (xpart point 4 of paths[p-1], 0);
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

endglyph;
