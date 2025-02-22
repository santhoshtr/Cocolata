input glyph;
beginglyph;
input ./glyphs/include/ഗ_;

p:=p+1;
input ./glyphs/include/right_arch_with_tail;

anchor( "vc", point 4 of paths[p]);
anchor( "bottom", (xpart(point 6 of paths[p]),0));
endglyph;
