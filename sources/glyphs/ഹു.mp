input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 2/3mw , y3);
z5 = ( x4- mw/3  ,(y4+y6)/2);
z6 = ( x4  , 0.9m);
z7 = ( x4 + mw/2, y5);
z8 = ( x4, -descent/2);
z9 = ( x7+thick/2, y8);


paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{right}z4{dir 160}..z5 ..z6{dir 10}..z7..{dir 200}z8{right} ..z9 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib )(3,4,5,6,7,8,9)
)(paths[p])(strokes[p]);

anchor( "vc", point 0.5 of paths[p]);
endglyph;
