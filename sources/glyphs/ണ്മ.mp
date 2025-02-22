input glyph;
beginglyph;
input ./glyphs/include/left_arch_with_eye;

% Second arch
p:=p+1;
input ./glyphs/include/middle_arch;

xshift:=xpart right_extrema(strokes[p]) - vertical_thin_nib_size/2;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

for i=3 upto 5:
  paths[i] := paths[i] shifted (xshift , yshift);
  strokes[i] := strokes[i] shifted (xshift , yshift);
endfor;

anchor( "right", (xpart point 1 of paths[4] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
