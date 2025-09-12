input glyph;
beginglyph;
input ./glyphs/include/ഋ;

clearxy;
p:=p+1;
z0 = point 6.7 of paths[p-1];
z1 = ((x0+x2)/2, y0);
z2 = point 5.3 of paths[p-1];
paths[p] = z0{dir 120}..{dir -70}z1{dir 70}..{dir -120}z2;
pen_stroke(
  nib(thicknib scaled 0.8)(0,1, 2)
)(paths[p])(strokes[p]);
endglyph;
