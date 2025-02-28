clearxy;
z0= (x1+ 0.1mw, 0.1m);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.7mw, 0.2m);

paths[p]:=z0..z1..z2{dir 10}..{down}z3  ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib rotated 30)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);