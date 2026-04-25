input glyph;
beginglyph;
clearxy;

z0= (x3 + mw/6, m/3);
z1= (x0+mw/4, 0.6m);
z2 = (x0+mw/2, y0);
z3 = ( mw/3, 0);
z4 = ( x2 + mw/2 , y3);
z5 = ( x4-m/3, m/2);
z6 = ( (x5+x7)/2, 0.95m);
z7 = ( x4 + 0.66mw, y5);
z8 = (x7-mw/6,undershoot);
z9 = (x8-mw/4,y5);
z10 = (0.9x7,0.6m);
z11 = (x10 +  mw/2, 0.3m);
z12 = (x7 , -0.8descent);
z13 = (x1, y12);
z14 = (0, m/2);
z15 = (x14+ mw/6, 0.9m);
paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{right}z4{dir 150}..z5 ..z6..z7
..z8..z9..z10..z11{down} ..z12{dir 190}..z13..z14..z15;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib)(3,4,5,6,7,8,9,10,11,12,13,14,15)
)(paths[p])(strokes[p]);

rbearing:=rbearing - thick;
anchor( "vc", point infinity of paths[0]);
anchor( "right", point 12 of paths[p]);
endglyph;
