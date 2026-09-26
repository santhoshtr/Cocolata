input glyph;
beginglyph
clearxy;
z0= (0, 0.45m);
z1= (0, (y0 + y2)/2.25);
z2 = ( (x1 + x3)/2.5, 0.85m); % top
z3 = ( x1 + 0.6mw, (y2+y4)/2);
z4 = ( x0 , undershoot);

paths[p]:=z0{dir 90}..z1..z2 ..z3{down}..z4  ;

paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1,2,3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);
endglyph;
