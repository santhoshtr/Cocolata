input glyph;
beginglyph;
input ./glyphs/include/left_arch_with_eye;

% Second arch
p:=p+1;
input ./glyphs/include/middle_arch;

p:=p+1;
input ./glyphs/include/_ഭ;

anchor( "vc", point 1 of paths[1]);
anchor( "right", point 6.5 of paths[p]);

endglyph;
