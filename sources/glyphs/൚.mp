input glyph;
beginglyph;

input ./glyphs/include/left_arch;
paths[p] := subpath(0,3.5) of paths[p];
pen_stroke(
    nib(thicknib
      rotated terminalangle 0 of paths[p])(0)
    nib(thicknib
    )(1)
    nib(thicknib
    )(2)
    nib(thicknib
    )(3,4)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;

z0= point infinity of paths[p-1];
z1= (x0+mw/4, m-overshoot);
z2 = (x1+mw/3, y0);
z3 = ( x1, 0);
z4 = ( x2 + mw/4 , y3);
z5 = ( x4-thick/2, m);


paths[p]:=z0{dir 90}...z1..{dir 240}z2..{left}z3{right}..{right}z4{dir 110}..{dir 80}z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);


endglyph;
