input glyph;
beginglyph;

input ./glyphs/include/ദ;
paths[p] :=subpath (0,4) of paths[p];
clearxy;
z0 = point infinity of paths[p] + (mw/2.5, -m/3);
paths[p] := paths[p]{right} ..{dir -80}z0;
pen_stroke(
    nib(thicknib)(0, 1, 2, 4, 5)
)(paths[p])(strokes[p]);


p:=p+1;
clearxy;
% ഋ sign
z0 = point 5 of paths[p-1];
z1 = (x0 - mw/2, -descent);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/6);
z4 = (x1 + mw/3, y2);
paths[p] =z0{dir angle(direction infinity of paths[p-1])}.. {left}z1..z2..z3..z4;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

endglyph;
