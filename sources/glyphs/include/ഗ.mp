
save dt;
z0 = (x1 + mw/4, m);
z1 = (0, (y0+y2)/2);
z2 = (x1 + mw/3, undershoot);
z3 = (x2 + mw/4, (y2 + y4)/2);
z4 = (x3 + mw/4, m - overshoot);
z5 = (x4 + mw/2.5, y1);
z6 = (x5 - mw/4, 0);
paths[p] = z0{dir 215}..z1{down}..z2{right}..z3{dir 95}..z4{right}..z5{down}..z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(end_nib rotated terminalangle 0 of paths[p])(0)
    nib(middle_up_nib scaled 1.2 rotated 30)(1)
    nib(downnib)(2)
    nib(middledownnib)(3)
    nib(top_nib rotated 10)(4)
    nib(middle_up_nib rotated 10 )(5)
    nib(end_nib rotated terminalangle 7 of paths[p])(7)
)(paths[p])(strokes[p]);
