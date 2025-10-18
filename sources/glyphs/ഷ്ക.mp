input glyph;
beginglyph;
input ./glyphs/include/ഷ;

p:=p+1;
clearxy;
input ./glyphs/include/ക;

for i=2 upto p:
    paths[i]:=paths[i] shifted (0.25mw, -1.05m) scaled 0.75 ;
    strokes[i]:=strokes[i] shifted (0.25mw, -1.05m) scaled 0.75 ;
endfor;

anchor( "vc", point 0.5 of paths[1]);

endglyph;
