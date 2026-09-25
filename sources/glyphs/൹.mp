input glyph;
beginglyph;

input ./glyphs/include/left_arch;

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_with_eye;
paths[p] := subpath(0, 4) of paths[p];
clearxy;
z0 = (point infinity of paths[p]) + (mw/2, m/4);
z1 = (x0 + mw/2, y0);
paths[p] := paths[p]{dir angle(direction 4 of paths[p])}..z0---z1;
pen_stroke(
    cut(thicknib, -45)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib)(8)
)(paths[p])(strokes[p]);
endglyph;
