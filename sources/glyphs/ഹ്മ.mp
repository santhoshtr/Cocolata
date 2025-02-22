input glyph;
beginglyph;
paths[p] := pa_mouth;
strokes[p] := pa_mouth_stroke(paths[p]);

clearxy;
p:=p+1;
z0=(0,0);
z1=z0 + (0.7mw,0);
paths[p]:= z0--z1 ;
paths[p]:= paths[p] shifted ( xpart(point infinity of paths[p-1])+thick/4, thick*thin_horizontal_nib_scale/2 );

pen_stroke(
    cut(thin_horizontal_nib, 30)(0)
    nib(thin_horizontal_nib)(1)
)(paths[p])(strokes[p]);
strokes[p]:= (xpart point infinity of strokes[p-1], ypart(point 0 of strokes[p])) -- subpath( 1, 3) of strokes[p]--cycle;


xshift:=xpart right_extrema(strokes[p]) - vertical_thin_nib_size/2;
yshift:=0;

p:=p+1;
clearxy;
input ./glyphs/include/മ;

for i=2 upto 4:
  paths[i] := paths[i] shifted (xshift , yshift);
  strokes[i] := strokes[i] shifted (xshift , yshift);
endfor;


anchor( "vc", point 0.5 of paths[1]);

anchor( "right", (xpart point 1 of paths[p-1] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
