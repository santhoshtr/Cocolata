clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0, (y0 + y2)/2);
z2 = ( x1 + mw/2, 0.9m); % top
z3 = ( x2 + mw/3, y2 - m/6);
z4 = ( x3 - mw/3, (y3+ y5)/2); % <
z5 = ( x3+ thick/4, 0.15m);
z6 = ( x4, undershoot );
paths[p] =z0{up}..{dir 10}z2..z3..{left}z4{right}..z5 ..  {left}z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib  )(0,1,2,3,4,5,6 )
)(paths[p])(strokes[p]);

