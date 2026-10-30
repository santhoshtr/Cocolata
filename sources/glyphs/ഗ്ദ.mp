input glyph;
beginglyph;
input ./glyphs/include/ഗ;

paths[p] := subpath (0, 4) of paths[p];
clearxy;
z5 = point 4 of paths[p];
z6 = (x5 + mw/3, (y5+y7)/2);
z7 = (x6 - mw/3, (y6+y8)/2);
z8 = (x6 + thick/4, (y7+y9)/2);
z9 = (x7, thin/2);
paths[p] := paths[p].. z6{down}..{left}z7{right}..z8{down}..{dir 160}z9;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7, 9)
)(paths[p])(strokes[p]);

anchor( "vc", point 3 of paths[p]);
anchor( "right", point 7.75 of paths[p]);
endglyph;
