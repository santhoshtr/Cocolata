input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..{dir -150}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 2/3mw , y3);
z5 = ( x4- mw/3  ,(y4+y6)/2);
z6 = ( x4  , 0.9m);
z7 = ( x4 + mw/2, y5);
z8 = ( x6, -0.8descent);
z9 = ( x8 - mw/3, y8 + m/4);
z10 = ( x9 + mw/2, y9);


paths[p]:=z3{right}..{right}z4{dir 160}..z5
    ..z6{dir 10}..z7{down}..z8..z9..{dir -40}z10 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib rotated -30)(2,3,4,5,6,7,8,9,10)
)(paths[p])(strokes[p]);

anchor( "vc", point 0.5 of paths[p]);
endglyph;
