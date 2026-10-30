input glyph;
beginglyph;
input ./glyphs/include/ഗ;

paths[p] := subpath (0, 4.8) of paths[p];

pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4, 5)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
% ഋ sign
z0 = point infinity of paths[p-1];
z1 = (x0 - 0.7mw, -descent);
z2 = (x1 - mw/4, y1+m/5);
z4 = ((x1 + x0)/2, y2);
paths[p] = z0{dir angle(direction infinity of paths[p-1])}.. {left}z1..z2.. {dir -60}z4;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

anchor( "vc", point 3 of paths[p]);

endglyph;
