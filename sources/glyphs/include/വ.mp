
clearxy;
z0= (0, 0.1m);
z1 = ( (x0 + x2)/2, 0.9m); % top
z2 = ( x0 +  0.8mw, (y1+y3)/1.6);
z3 = ( x1   , 0); % bottom middle
z4 = ( x2 + mw/3, y3);
z5 = ( x4, 1.1m);

paths[p]:=z0{up} ..z1{dir 20}..z2..{left}z3{right}..{right}z4{dir 100}..{dir 80}z5  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.2)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib scaled 1.2 rotated 0)(6)
)(paths[p])(strokes[p]);
