input glyph;
beginglyph;
input ./glyphs/include/ണ;

xshift := 0.6mw;
yshift := -m;

p:=p+1;
clearxy;
input ./glyphs/include/ണ;

for i=3 upto 5:
  paths[i] := paths[i] shifted (xshift , yshift) xscaled 0.8 yscaled 0.75;
  strokes[i] := strokes[i] shifted (xshift , yshift) xscaled 0.8 yscaled 0.75;
endfor;

endglyph;
