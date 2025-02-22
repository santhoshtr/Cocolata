input glyph;
beginglyph;
input ./glyphs/include/left_arch;

% Second arch
p:=p+1;
input ./glyphs/include/middle_arch;

p:=p+1;
input ./glyphs/include/right_arch;
clearxy;
z4= (xpart point 1 of paths[p], -descent);
paths[p]:=subpath(0,3) of paths[p] ..z4;
pen_stroke(
    cut(thin_vertical_nib, -45)(0)
    nib(thin_vertical_nib)(1)
    nib(top_nib)(2)
    nib(middle_down_nib)(3)
    nib(end_nib rotated terminalangle 4 of paths[p])(4)
)(paths[p])(strokes[p]);


endglyph;
