input glyph;
beginglyph;

input ./glyphs/include/പ;

% ന

p:=p+1;
input ./glyphs/include/left_arch;

p:=p+1;
input ./glyphs/include/right_arch;

xshift:=0.4mw;
yshift:=-1m;
paths[p-1] := paths[p-1] shifted (xshift, yshift) xscaled 0.75 yscaled 0.75;
strokes[p-1] := strokes[p-1] shifted (xshift, yshift) xscaled 0.75 yscaled 0.75;
paths[p] := paths[p] shifted (xshift, yshift) xscaled 0.75 yscaled 0.75;
strokes[p] := strokes[p] shifted (xshift, yshift) xscaled 0.75 yscaled 0.75;


anchor( "vc", point 0.5 of paths[1]);

endglyph;
