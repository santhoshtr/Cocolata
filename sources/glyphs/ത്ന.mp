input glyph;
beginglyph;
input ./glyphs/include/ത_;

clearxy;
p:=p+1;
input ./glyphs/include/right_arch;

anchor( "vc", (xpart(point 4 of paths[0]),0));
anchor( "bottom", point 3.3 of paths[1]);
anchor( "right", point 3.3 of paths[1]);
endglyph;
