clearxy;
z0= (0, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/4 , 0); % bottom middle


paths[p]:=z0..z1..z2{right}..z3..z4  ;

paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib scaled 1.2)(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.3)(3)
    nib(thicknib)(4)

)(paths[p])(strokes[p]);
