

clearxy;

z0= (x1 + thick/2, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.8mw, (y2+y4)/1.6);
z4 = ( (x3+x5)/2 , 0); % bottom middle
z5 = ( x2, m/2);
z6 =(x5 + mw/2, 0.8m);
z7 =(x6 + mw/2.5, (y6+y8)/2);
z8 = (x4, -m/3);
z9 = (x7+ thick/2, y8   );

paths[p]:=z0..z1..z2{right}..z3..z4..z5.. z6..z7  ..{dir 200}z8{dir 10}.. z9;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib  )(0)
    nib(thicknib  )(1)
    nib(thicknib  )(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib )(7)
    nib(thicknib )(8)
    nib(thicknib )(9)
)(paths[p])(strokes[p]);