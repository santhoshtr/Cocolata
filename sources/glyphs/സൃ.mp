input glyph;
beginglyph;

input ./glyphs/include/സ;


p:=p+1;
clearxy;
% ഋ sign
z0 = point 6.25 of paths[p-1];
z1 = (x0 - 0.75mw, -descent);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/6);
z4 = (x1 + mw/3, y2);
paths[p] = z0{dir angle(direction 6.25 of paths[p-1])*-1}.. {left}z1..z2{up}..z3..z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(middle_up_nib)(0)
    nib(down_nib)(1)
    nib(topnib)(2,3)
    nib(end_nib rotated terminalangle 4 of paths[p])(4)
)(paths[p])(strokes[p]);
anchor( "vc", (x3,0));
anchor( "bottom", point 5 of paths[1]);
anchor( "right", point 5 of paths[1]);

endglyph;
