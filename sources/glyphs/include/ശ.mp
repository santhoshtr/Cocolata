
save dt;
z0 = (x1 + mw/4, m);
z1 = (0, (y0+y2)/2);
z2 = (x1 + mw/3, undershoot);
z3 = (x2 + mw/4, (y2 + y4)/2);
z4 = (x3 + mw/3, m - overshoot);
z5 = (x4 + mw/2, (y4+y6)/2);
z6 = (x5 - mw/3.5, undershoot);
z7 = (x6 - mw/4, y6 + m/3);

paths[p] = z0{dir 215}..z1{down}..z2{right}..z3{dir 95}..z4{right}..z5{dir -80}..z6{left}..{up}z7;
z8 = point 4.6 of paths[p];
paths[p] := paths[p] .. z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(end_nib rotated terminalangle 0 of paths[p])(0)
    nib(middle_up_nib scaled 1.2 rotated 30)(1)
    nib(down_nib rotated -20)(2)
    nib(middle_down_nib)(3)
    nib(top_nib rotated 10)(4)
    nib(middle_down_nib)(5)
    nib(down_nib rotated -15)(6)
    nib(middle_up_nib scaled 1.2)(7)
    nib(end_nib rotated terminalangle 8 of paths[p])(8)
)(paths[p])(strokes[p]);