input glyph;
beginglyph;
input ./glyphs/include/left_arch;

% Second arch
p:=p+1;
input ./glyphs/include/middle_arch;

p:=p+1;
input ./glyphs/include/right_arch;
clearxy;
z4= (xpart point 0 of paths[p], -descent/2);
paths[p]:=subpath(0,2) of paths[p] ..{left}z4;
pen_stroke(
    cut(thicknib, -45)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib rotated terminalangle 4 of paths[p])(4)
)(paths[p])(strokes[p]);


endglyph;
