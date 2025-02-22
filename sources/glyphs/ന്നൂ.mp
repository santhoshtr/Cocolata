input glyph;
beginglyph;

input ./glyphs/include/left_arch;

% Second arch
p:=p+1;
input ./glyphs/include/middle_arch;

p:=p+1;
input ./glyphs/include/right_arch_with_tail;

anchor( "vc", (xpart(point 1 of paths[1]),0));
endglyph;
