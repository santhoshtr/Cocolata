clearxy;
z0= (x1+thick/2, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/2);
z4 = ( x3- mw/6 , undershoot); % bottom middle


paths[p]:=z0..z1..z2{dir 20}..z3..z4  ;

paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib  )(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)

)(paths[p])(strokes[p]);
