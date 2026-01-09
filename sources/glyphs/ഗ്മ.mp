input glyph;
beginglyph;
input ./glyphs/include/ഗ_;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

xshift := xpart point infinity of paths[p-1];
yshift := 0;
paths[p] := paths[p] shifted (xshift , yshift);
strokes[p] := strokes[p] shifted (xshift , yshift);

anchor( "vc", point 4 of paths[p]);
anchor( "right", (xpart point 4 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
