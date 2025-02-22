clearxy;
z0 = (xpart right_extrema(strokes[p-1]) - vertical_thin_nib_size/2, vertical_thin_nib_size/2);
z1=(x0, 0.6m);
z2=((x1+x3)/2, m-overshoot); % Top of arch
x3-x1 = 0.6mw;
z3=(x3, y1);
z4=(x3, 0);

paths[p] =  z0---z1..z2..z3---z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    cut(thin_vertical_nib, -45)(0)
    nib(thin_vertical_nib)(1)
    nib(top_nib)(2)
    nib(thick_vertical_nib)(3)
    nib(thick_vertical_nib)(4)
)(paths[p])(strokes[p]);
