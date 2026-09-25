input glyph;
beginglyph;


input ./glyphs/include/left_arch_dha;

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

p:=p+1;
clearxy;
% bottom tail
z0 = point 1.5 of paths[p-2];
z1 = (x0 - mw/4, -0.75descent);
paths[p] = z0{down}.. {left}z1;
pen_stroke(
    cut(thicknib, -45)(0)
    nib(thicknib)(1)
)(paths[p])(strokes[p]);


endglyph;
