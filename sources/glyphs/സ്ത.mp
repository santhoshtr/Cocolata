input glyph;
beginglyph;
input ./glyphs/include/സ;

p:=p+1;
clearxy;
input ./glyphs/include/ത;

paths[p]:=paths[p] shifted (mw, -0.95m) scaled 0.75 ;
strokes[p]:=strokes[p] shifted (mw, -0.95m) scaled 0.75 ;

anchor( "vc", (x3,0));

endglyph;
