input glyph;
beginglyph;
input ./glyphs/include/ത_;

xshift:=xpart right_extrema(strokes[p]) - vertical_thin_nib_size/2;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/_മ;


anchor( "vc", (xpart(point infinity of paths[0]),0));
anchor( "right", (xpart point 4 of paths[1] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
