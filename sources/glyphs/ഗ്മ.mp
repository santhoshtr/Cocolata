input glyph;
beginglyph;
input ./glyphs/include/ഗ_;

xshift:=xpart right_extrema(strokes[p]) - vertical_thin_nib_size/2;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

xshift := xpart point infinity of paths[p-1];
yshift :=  ypart point infinity of paths[p-1];
paths[p] := paths[p] shifted (xshift , yshift);
strokes[p] := strokes[p] shifted (xshift , yshift);

anchor( "vc", point 4 of paths[p]);
anchor( "right", (xpart point 4 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
