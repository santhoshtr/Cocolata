clearxy;
path l;
z0 = (xpart right_extrema(strokes[p-1]) - vertical_thin_nib_size/2, vertical_thin_nib_size/2);
z1=(x0, 0.6m);
z2=((x1 + x3)/2.1, m-overshoot);
z3=(x1 + 0.9mw, (y2+y4)/2.4);
z4=((x3 + x5)/2, undershoot); % Bottom
z5=(x3 -0.55*mw, y4 + m/3);
l=z0---z1..z2..z3..z4..z5;
z6=point 2.8 of l;
paths[p] := z0---z1..z2{right}..z3{down}..z4{left}..z5..z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    cut(thin_vertical_nib, -45)(0)
    nib(thin_vertical_nib)(1)
    nib(top_nib)(2)
    nib(middle_down_nib)(3)
    nib(downnib)(4)
    nib(middleupnib)(5)
    nib(end_nib rotated terminalangle infinity of paths[p] )(6)
)(paths[p])(strokes[p]);
