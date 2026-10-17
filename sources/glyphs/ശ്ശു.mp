input glyph;
beginglyph;

input ./glyphs/include/ശ;

p:=p+1;
input ./glyphs/include/ശു;
paths[p] := paths[p]  shifted (0.35mw, -1.1m) xscaled 0.8 yscaled 0.75;
strokes[p] := strokes[p]  shifted (0.35mw, -1.1m) xscaled 0.8 yscaled 0.75;
rbearing:=-rbearing*3;
endglyph;
