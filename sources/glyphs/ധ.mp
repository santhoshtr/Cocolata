input glyph;
beginglyph;

input ./glyphs/include/left_arch_dha;

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;
xshift:= xpart right_extrema(strokes[p-1]) - vertical_thin_nib_size + thick/2;
paths[p]:=paths[p] shifted (xshift, 0);
strokes[p]:=strokes[p] shifted (xshift, 0);

anchor( "vc", (xpart(point 3 of paths[0]),0));
anchor( "right", point 2.2 of paths[1]);
endglyph;
