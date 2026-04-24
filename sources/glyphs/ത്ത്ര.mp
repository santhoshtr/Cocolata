input glyph;
beginglyph;
input ./glyphs/include/ത_;

paths[p] := paths[p]  shifted (mw/3,0);
strokes[p] := strokes[p]  shifted (mw/3,0);

p:=p+1;
clearxy;
input ./glyphs/include/_ത്ര;

anchor( "vc", (xpart(point infinity of paths[0]),0));
anchor( "right", point 6.5 of paths[p]);
endglyph;
