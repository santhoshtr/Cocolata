input glyph;
beginglyph;
clearxy;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, thick/4);
z4 = ( x2 + 2/3mw , y3);
z5 = ( x4 - mw/3  ,(y4+y6)/2);
z6 = ( x5 + mw/3 , 0.9m);
z7 = ( x6 + mw/3, 0.2m);

paths[p]:=z0{dir 90}..z1..z2..{left}z3{right}..{right}z4{dir 160}..z5 ..z6{dir 10}..{down}z7 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib scaled 0.8)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib )(3,4,5,6,7)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch;

anchor( "vc", point 0.5 of paths[p]);
anchor( "bottom",(xpart(point 3 of paths[p]), 0));
anchor( "right",  point infinity of paths[p]);
endglyph;
