input glyph;
beginglyph;

input ./glyphs/include/ക;
paths[p] := paths[p]  shifted (mw/3,0);
strokes[p] := strokes[p]  shifted (mw/3,0);
p:=p+1;
clearxy;
input ./glyphs/include/_ത്ര;

anchor( "vc", point infinity of paths[p]);
anchor( "right", point 6.5 of paths[p]);

endglyph;
