input glyph;
beginglyph;
input ./glyphs/include/ബ;

p:=p+1;
clearxy;
paths[p] = vocalic_r_sign shifted (xpart point infinity of paths[p-1], 0);
pen_stroke(
   nib(thicknib  )(0,1,2,3,4 )
)(paths[p])(strokes[p]);


endglyph;
