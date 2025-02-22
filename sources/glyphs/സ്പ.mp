input glyph;
beginglyph;
input ./glyphs/include/സ;

p:=p+1;
input ./glyphs/include/പ;

xshift := 1.2mw;
yshift := -0.75m;


paths[p] := paths[p] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;
strokes[p] := strokes[p] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;


anchor( "vc", point 0.5 of paths[1]);

endglyph;
