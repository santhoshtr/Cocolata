input glyph;
beginglyph;

input ./glyphs/include/ഗ;

paths[p] := subpath (0, 4) of paths[p];
clearxy;
z6 = (xpart point infinity of paths[p] + mw/3, (m-overshoot+y7)/2);
z7 = (x6 - mw/3, m/1.75);

paths[p] := paths[p]{right}.. z6{down}..{left}z7 ;
paths[p] := subpath(0, 7) of paths[p];
pen_stroke(
    nib(thicknib)(0, 1, 2, 3,4,5,6,7)
)(paths[p])(strokes[p]);

% Connector
clearxy;
p:=p+1;
z0= point infinity of paths[p-1];
z1=(x0 + mw/3, (y0 + y2)/2);
z2=(x1 - mw/4, (y1 + y3)/2);
z3=(x2 + mw/4, overshoot);
z4=(x3 + mw/2.5, 0.9m);
paths[p] = z0{right}.. z1{down}.. z2{down} ..{right}z3..{up}z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;


anchor( "vc", point 0.5 of paths[p-1]);
anchor( "right", point 2.3 of paths[p]);
endglyph;
