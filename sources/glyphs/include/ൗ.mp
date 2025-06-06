clearxy;

% Malayalam AU sign
z0= (0, 0.7m);
z1= (x0+ mw/3, 0.45m);
z2= (x1, (y1 + y3)/2.25);
z3 = ( (x2 + x4)/2.5, 0.85m); % top
z4 = ( x1 + 0.6mw, (y2+y4)/2);
z5 = ( x1 , undershoot);

paths[p]:=z0{dir 75}..{down}z1{dir 90}..z2..z3 ..z4{down}..z5  ;

paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib )(2)
    nib(thicknib )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);
