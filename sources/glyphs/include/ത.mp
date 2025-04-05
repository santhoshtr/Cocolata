clearxy;


z0= (x1 + thick/2, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/4 , undershoot); % bottom middle
z5 = ( (x1+x3)/2.2, m/2);
z6 =(x5 + mw/2, 0.85m);
z7 =(x6 + mw/2.5, 0.5m);
z8 =(x7 - thick/2, undershoot);

paths[p]:=z0..z1..z2..z3..z4..z5..z6..z7..z8  ;
paths[p] :=harmonize(paths[p]);
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