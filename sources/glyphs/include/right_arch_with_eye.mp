clearxy;
z0 = point infinity of paths[p-1];
z1=(x0, 0.6m);
z2=((x1 + x3)/2.1, 0.9m);
z3=(x1 + 0.9mw, (y2+y4)/2.4);
z4=((x3 + x5)/2, undershoot); % Bottom
z5=(x3 -0.55*mw, y4 + m/3);
z6=(x3 - mw/6, 0.5m);

paths[p] := z0{up}..z2{dir 20}..z3{down}..z4 ..z5..z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib rotated 30)(0)
    nib(thicknib)(1,2,3,4,5)
    nib(thicknib rotated -30)(6)
)(paths[p])(strokes[p]);
