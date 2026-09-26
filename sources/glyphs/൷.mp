input glyph;
beginglyph;
z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..{left}z3;
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
z4 = ( x2 + mw , y3);
z5 = ( x4 - mw/3  ,(y4+y6)/2);
z6 = ( x5 + mw/3 , 0.9m);
z7 = ( x6 + mw/3, 0.2m);

paths[p]:=z3{right}..{right}z4{dir 160}..z5 ..z6{dir 10}..{down}z7 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib )(2)
    nib(thicknib )(3,4,5,6,7)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
input ./glyphs/include/right_arch_with_eye;
paths[p] := subpath(0, 4) of paths[p];
clearxy;
z0 = (point infinity of paths[p]) + (mw/2, m/4);
z1 = (x0 + mw/2, y0+ m/4);
paths[p] := paths[p]{dir angle(direction 4 of paths[p])}..z0..z1;
pen_stroke(
    cut(thicknib, -45)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib)(8)
)(paths[p])(strokes[p]);

anchor( "vc", point 0.5 of paths[1]);

endglyph;
