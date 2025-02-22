input glyph;
beginglyph;

input ./glyphs/include/left_arch;

p:=p+1;
input ./glyphs/include/right_arch;
paths[p] := subpath(0, 2.75) of paths[p] ;

pen_stroke(
    cut(thin_vertical_nib, -45)(0)
    nib(thin_vertical_nib)(1)
    nib(top_nib)(2)
    nib(middle_down_nib)(3)
)(paths[p])(strokes[p]);


p:=p+1;
clearxy;
% ഋ sign
z0 = point infinity of paths[p-1];
z1 = (x0 - 0.75mw, -descent);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/5);

paths[p] = z0{dir angle(direction infinity of paths[p-1])}.. {left}z1..z2{up}..z3{right};
z4 = point 2/3 of paths[p];
paths[p] := paths[p] .. z4;

pen_stroke(
    nib(middle_down_nib)(0)
    nib(down_nib)(1)
    nib(topnib)(2,3,4)
)(paths[p])(strokes[p]);
endglyph;
