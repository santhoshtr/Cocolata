input glyph;
beginglyph;
input ./glyphs/include/ഒ;


clearxy;
p:=p+1;
xshift:=xpart point 15 of strokes[p-1];
input ./glyphs/include/ൗ;

for i=1 upto p:
    paths[i] := paths[i] shifted (xshift, 0);
    strokes[i] := strokes[i] shifted (xshift, 0);
endfor;

endglyph;
