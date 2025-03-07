input glyph;
beginglyph;
input ./glyphs/include/െ;

% Au sign
clearxy;
p:=p+1;
xshift:=xpart point 6 of paths[p-1] + mw/6;
input ./glyphs/include/ൗ;

for i=1 upto p:
    paths[i] := paths[i] shifted (xshift, 0);
    strokes[i] := strokes[i] shifted (xshift, 0);
endfor;

endglyph;