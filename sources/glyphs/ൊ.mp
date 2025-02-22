input glyph;
beginglyph;
input ./glyphs/include/െ;

clearxy;
p:=p+1;

input ./glyphs/include/ാ;

paths[p] := paths[p]  shifted(xpart(point 6 of paths[p-1]) + mw/2, 0);
strokes[p] := strokes[p]  shifted(xpart(point 6 of paths[p-1]) + mw/2, 0);

endglyph;
