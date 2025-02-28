clearxy;

z0 =  point infinity of paths[p-1];
z1= (x0, 0.6m);
z2 = ( x1 + mw/3, 0.85m); % top
z3 = ( x2 + mw/2, (y2+y4)/2.5);
z4 = ( x3 - mw/4, 0.15m); % bottom middle
z5 = ( x4 - mw/4, y3);
z6 = ( x5 + mw/2, 0.75m); % second top
z7 = ( x6 + mw/3, 0.6m);
z8 = ( x7, 0.2m);
paths[p]:=z0{up} ..z2{dir 30} ..z3 ..z4 ..z5 ..z6 ..{down}z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
  nib(thicknib )(0)
    nib(thicknib  )(1)
    nib(thicknib )(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib )(7)
    nib(thicknib)(8)
)(paths[p])(strokes[p]);
