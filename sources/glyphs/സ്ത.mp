input glyph;
beginglyph;
input ./glyphs/include/സ;


% Make room for ത
paths[p] := paths[p] yscaled 0.9 shifted (0, 0.1m);
strokes[p] := strokes[p] yscaled 0.9 shifted (0, 0.1m);

p:=p+1;
clearxy;
input ./glyphs/include/ത;

paths[p]:=paths[p] shifted (mw, -0.95m) scaled 0.8 ;
strokes[p]:=strokes[p] shifted (mw, -0.95m) scaled 0.8 ;

anchor( "vc", (x3,0));

endglyph;
