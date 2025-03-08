

clearxy;

z0 =  point infinity of paths[p-1];
z1= (x0, (y0 + y2)/2);
z2 = ( x1+ mw/2.5, y0+0.65m); % top
z3 = ( x1 + 0.8mw, (y2+y4)/1.6);
z4 = ( (x3+x5)/2 , y0 - 0.2m + undershoot); % bottom middle
z5 = ( x2, y0 - 0.2m + m/2);
z6 =(x5 + mw/2, y5 + 0.4m);
z7 =(x6 + mw/2.5, y6 - 0.5m);
z8 =(x7 - 0.2mw, y7 - 0.4m + undershoot);

paths[p]:=z0{up}..{dir 20}z2..z3..z4..z5..{dir 20}z6..z7{down}..z8  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib )(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
    nib(thicknib rotated 30)(7)
    nib(thicknib)(8)
)(paths[p])(strokes[p]);