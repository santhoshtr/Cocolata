input glyph;
beginglyph;
input ./glyphs/include/ഡ;

p:=p+1;
clearxy;
% ഋ sign
z0 = point 3.25 of paths[p-1];
z1 = (x0 - 0.75mw, -descent*1.2);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/5);
paths[p] = z0{dir angle(direction 3.25 of paths[p-1]*-1)}.. {left}z1..z2{up}..{right}z3;

z4 = point 2/3 of paths[p];

paths[p] := paths[p]{right}..z4;

pen_stroke(
    nib(middle_up_nib)(0)
    nib(down_nib)(1)
    nib(topnib)(2,3,4)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart( point infinity of paths[0]),0));
endglyph;
