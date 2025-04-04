input glyph;
beginglyph;
input ./glyphs/include/left_arch_with_eye;

% Second arch
p:=p+1;
input ./glyphs/include/middle_arch;

xshift:=xpart point infinity of paths[p];
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/_മ;

anchor( "right", (xpart point 4 of paths[2] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
