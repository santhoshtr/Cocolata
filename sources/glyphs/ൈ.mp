input glyph;
beginglyph;

input ./glyphs/include/െ;
p:=p+1;
input ./glyphs/include/െ;

for i=2 upto p:
    paths[i] := paths[i] shifted (1.2mw, 0);
    strokes[i] := strokes[i] shifted (1.2mw, 0);
endfor;


endglyph;
