input glyph;

beginglyph;

input ./glyphs/include/left_arch;

xshift:=xpart right_extrema(paths[p])  ;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

paths[p] := paths[p] shifted (xshift , yshift);
strokes[p] := strokes[p] shifted (xshift , yshift);


anchor( "vc", (xpart(point infinity of paths[0]),0));
anchor( "right", (xpart point 4 of paths[1] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
