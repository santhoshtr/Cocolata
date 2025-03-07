input glyph;
beginglyph;
input ./glyphs/include/ഋ;

clearxy;
p:=p+1;
z0 = (xpart(point 0 of paths[p-1]),0);
z1 = ((x0+x2)/2, y0);
z2 = (xpart(point 5 of paths[p-1]), y0);
paths[p] = z0{dir 100}..{dir -70}z1{dir 70}..{dir -100}z2;
pen_stroke(
 nib(thicknib scaled 0.8)(0,1, 2)
)(paths[p])(strokes[p]);
endglyph;
