input glyph;
beginglyph;
input ./glyphs/include/ഗ_;

xshift:=xpart right_extrema(strokes[p]) - vertical_thin_nib_size/2;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

for i=1 upto 3:
  paths[i] := paths[i] shifted (xshift , yshift);
  strokes[i] := strokes[i] shifted (xshift , yshift);
endfor;

anchor( "vc", point 4 of paths[p]);
anchor( "right", (xpart point 1 of paths[p-1] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
