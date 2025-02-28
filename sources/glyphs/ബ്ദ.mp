input glyph;
beginglyph;
input ./glyphs/include/ബ;


p:=p+1;
clearxy;
input ./glyphs/include/ദ;

paths[p] := paths[p] shifted (1.56mw, -m) xscaled 0.8 yscaled 0.75;
strokes[p] := strokes[p] shifted (1.56mw, -m) xscaled 0.8 yscaled 0.75;

anchor( "vc", (xpart(point 5 of paths[0]),0));

endglyph;
