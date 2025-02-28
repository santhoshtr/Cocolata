input glyph;
beginglyph;
input ./glyphs/include/left_arch;

p:=p+1;
clearxy;
input ./glyphs/include/right_chillu;

p:=p+1;
xshift = 1.3mw;
yshift = -1.05m;
input ./glyphs/include/റ;
paths[p] := paths[p] shifted (xshift, yshift ) xscaled 0.75 yscaled 0.7;
strokes[p] := strokes[p] shifted (xshift, yshift ) xscaled 0.75 yscaled 0.7;

rbearing:=rbearing/2;

anchor( "vc", (xpart(point 4 of paths[0]),0));
anchor( "right", point 4 of paths[2]);

endglyph;
