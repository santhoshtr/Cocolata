input glyph;
beginglyph;
input ./glyphs/include/ക;

p:=p+1;
clearxy;
z0=point 6.3 of paths[p-1];
z1=(0, (y0+y2)/2);
z2=((x1+x3)/2, m-overshoot);
z3=point 0 of paths[p-1];
paths[p] := z0{left}..z1{up}..z2{right}..{down}z3;
paths[p] := harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

anchor( "vc", point 1 of paths[p-1]);

endglyph;
