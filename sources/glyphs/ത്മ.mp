input glyph;
beginglyph;
input ./glyphs/include/ത_;

xshift:=xpart right_extrema(strokes[p]) - vertical_thin_nib_size/2;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

for i=1 upto 3:
  paths[i] := paths[i] shifted (xshift , yshift);
  strokes[i] := strokes[i] shifted (xshift , yshift);
endfor;

anchor( "vc", (xpart(point infinity of paths[0]),0));
anchor( "right", (xpart point 1 of paths[2] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
