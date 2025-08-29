input glyph;
beginglyph;
input ./glyphs/include/ഷ;

clearxy;
p:=p+1;
input ./glyphs/include/പ;

xshift := 0.6mw;
yshift := -0.75m;

for i=2 upto p:
    paths[i]:=paths[i] shifted (xshift, yshift) scaled 0.75 ;
    strokes[i]:=strokes[i] shifted (xshift, yshift) scaled 0.75 ;
endfor;

anchor( "vc", point 0.5 of paths[1]);

endglyph;
