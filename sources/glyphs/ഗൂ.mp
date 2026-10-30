input glyph;
beginglyph;
input ./glyphs/include/ഗ;

paths[p] := subpath (0, 4) of paths[p];
clearxy;
z5 = point 4 of paths[p];
z6 = (x5 + mw/3, (y5+y7)/2);
z7 = (x6 - mw/3, (y6+y8)/2);
z8 = (x7 + mw/2.5, 0.2m);
% The bottom tail is the same as in ഗു: a corner, then a flat stroke.
z9 = (xpart point 2 of paths[p], -descent/2);
z10 = (x8, y9);
paths[p] := paths[p].. z6{down}..{left}z7{right}..z8{down}..{dir 200}z9{dir 10}..z10;

pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
)(paths[p])(strokes[p]);

anchor( "vc", point 3 of paths[p]);
endglyph;
