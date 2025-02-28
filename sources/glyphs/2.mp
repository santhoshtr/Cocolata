input glyph;
beginglyph;
z0= (0,0.66m);
z1 = ( (x0 + x2)/2, m); % top
z2 = ( x0 +  0.68mw, (y1+y3)/1.5);
z3 = ( x0   , 0);
z4 = ( x2   ,y3);

paths[p]:=z0 ..z1 ..z2..{dir 245}z3{dir 5}.. z4   ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib scaled 1.2 rotated 0)(6)
)(paths[p])(strokes[p]);


endglyph;