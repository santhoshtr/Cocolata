input glyph;
beginglyph;
input ./glyphs/include/സ;

p:=p+1;
input ./glyphs/include/left_arch;

p:=p+1;
input ./glyphs/include/right_arch_with_tail;

xshift:=0.5mw;
yshift:=-0.9m;
paths[p-1] := paths[p-1] shifted (xshift, yshift) xscaled 0.8 yscaled 0.8;
strokes[p-1] := strokes[p-1] shifted (xshift, yshift) xscaled 0.8 yscaled 0.8;
paths[p] := paths[p] shifted (xshift, yshift) xscaled 0.8 yscaled 0.8;
strokes[p] := strokes[p] shifted (xshift, yshift) xscaled 0.8 yscaled 0.8;


anchor( "vc", (x3,0));

endglyph;
