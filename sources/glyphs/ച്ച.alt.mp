input glyph;
beginglyph;
clearxy;
z0= ( mw/6, 0.4m);
z1= (x0 + mw/6, 0.6m);
z2 = (x0 +mw/3, y0);
z3 = (x2 + mw/6, y1);
z4 = (x3+ mw/6, y2);
z5 = (x0,0);
z6 = ( x4 + mw/3, y5);
z7 = ( x6 , m);

paths[p]:=z0{dir 90}..z1..{down}z2{up}..{right}z3..z4..{left}z5{right}..{right}z6{dir 100}..z7;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib)(3,4,5,6,7)
)(paths[p])(strokes[p]);

anchor( "vc", point infinity of paths[0]);
anchor( "right", (xpart point infinity of paths[p] - mw/5, 0) );
endglyph;
