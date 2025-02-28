clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0 + mw/4, 0.9m); % top
z2 = ( x0 + 0.8mw, (y1+y3)/1.6);
z3 = ( x2 - mw/4 , undershoot); % bottom middle
z4 = ( x3 - mw/4, m/2);
z5 = (x3, X);

paths[p]:=z0{up}..z1{dir 20}..z2 ..z3..z4{dir 60} .. {dir 120}z5  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib  )(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.3)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);

