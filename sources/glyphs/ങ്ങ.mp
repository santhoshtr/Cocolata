input glyph;
beginglyph;
clearxy;
z0 =(thick, (y1 + y3)/1.5);
z1 =((x0 + x2)/2, y3 +0.45m);
z2=(x0 + mw/3, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(0, (y3 + y5)/2);
z5=(x4 + 0.45mw, m);
z6=(x7 + mw/4, (y5+y7)/2);
z7=(x5 + mw/3, (y5+y9)/2.2);
z8=(x7 + mw/3, (y7+y9)/2);
z9=(x7, undershoot);
z10=(x7 -mw/4, y7);
z11=((x10 + x12)/2, 0.8m);
z12=(x0 + 1.25mw, 0.2m);

paths[p] := z0{dir 80}..z1..z2..z3..z4..z5..z6
    ..{left}z7{right}..z8..z9..z10..z11..{down}z12;
pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11,12)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
input ./glyphs/include/_ദ;

anchor( "vc", point 0 of paths[p]);
anchor( "bottom", point 4.5 of paths[p]);
anchor( "right", point 4.5 of paths[p]);

endglyph;
