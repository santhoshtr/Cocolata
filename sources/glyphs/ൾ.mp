input glyph;
beginglyph;
clearxy;
z0 = (0, 0.8m);
z1= (x0+mw/4, 4undershoot);
z2= (x1+mw/4, (y1 + y3)/2);
z3 = ( (x2 + x4)/2.5, 0.9m); % top
z4 = ( x2 + 0.8mw, (y3+y5)/1.6);
z5 = ( x3+ mw/4 , undershoot); % bottom middle
z6 = ( (x2+x4)/2.4, m/2);
z7 = (x4, X);

paths[p]:=z0{dir 260}..{dir 0}z1..z2..z3 ..z4{down}..z5..z6 .. z7; ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib scaled 1.2)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5,6)
)(paths[p])(strokes[p]);


endglyph;
