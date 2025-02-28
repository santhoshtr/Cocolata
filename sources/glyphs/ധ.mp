input glyph;
beginglyph;

input ./glyphs/include/left_arch_dha;

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "right", point 1.2 of paths[1]);
endglyph;
