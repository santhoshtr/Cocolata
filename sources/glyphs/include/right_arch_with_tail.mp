clearxy;

z0 = point infinity of paths[p-1];
z1=((x0 + x3)/2, 0.9m);
z2=(x0 + 0.9mw, (y2+y4)/2);
z3=((x2 + x4)/2, 0.1m); % Bottom
z4=(x3 - mw/4, y3 + m/3);
z5=(x4  + mw/3, y4 + m/3);
z6=(x5  + mw/2, y2);
z7=(x1, -m/3);

paths[p] := z0{up}..z1{dir 20}..z2{down}..z3{dir 210}..z4..z5..z6..z7;
paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib  )(0)
    nib(thicknib)(1,2,3,4,5,6)
    nib(thicknib rotated -20)(7)
)(paths[p])(strokes[p]);
