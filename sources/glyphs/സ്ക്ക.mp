input glyph;
beginglyph;

input ./glyphs/include/സ;

% Make room for ക്ക
paths[p] := paths[p] yscaled 0.9 shifted (0, 0.1m);
strokes[p] := strokes[p] yscaled 0.9 shifted (0, 0.1m);

p:=p+1;
clearxy;
input ./glyphs/include/ക്ക;

for i=2 upto p:
    paths[i]:=paths[i] shifted (0.15mw, -1m) scaled 0.8 ;
    strokes[i]:=strokes[i] shifted (0.15mw, -1m) scaled 0.8 ;
endfor;


anchor( "vc", (xpart point 3 of paths[0],0));

endglyph;
