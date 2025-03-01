input glyph;
beginglyph;

clearxy;
z0=(mw/2, 0.65m);
z1=((x0 + x2)/2.25, m-overshoot);
z2=(x0 + 0.5mw, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(x0, m/3);
z5=(x4-mw/4, y3);
z6=(x5-mw/4, 0.3m);
z7=(x1, 0.65m);
z8=(x2 + mw/2, 4undershoot);
z9=(x2, y4);
z10=(x8, 0.9m);
z11=(x10 + mw/2, (y10+y12)/2);
z12=(x11 - mw/4, (y10+y14)/2); % <
z13=(x12 + mw/3, (y12+y14)/2);
z14=(x12, undershoot);

paths[p] := z0 ..{right}z1..{down}z2..z3{left}..{up}z4{down}..z5{left}
..{dir 60}z6.. z7..z8 .. {up}z9..z10
..z11..{dir 190}z12{dir -10}..z13..{dir 170}z14;
paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11,12,13,14)
)(paths[p])(strokes[p]);

anchor( "vc", point 1 of paths[0]);

endglyph;
