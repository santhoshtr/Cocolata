input glyph;
beginglyph
clearxy;
z0= (0, m);
z1= (0, (y0 + y2)/2.25);
z2 = ( (x1 + x3)/2.5, X); % top
z3 = ( x1 + 0.6mw, m);
z4 = ( x3 , -0.2m);

paths[p]:=z0{dir 90}..z1..z2 ..z3...z4   ;

paths[p] :=harmonize(paths[p]);
paths[0] := paths[0] shifted (-x3 + 2/3thick , 0);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib )(3,4)
)(paths[p])(strokes[p]);
absolute_position := 1;
endglyph;
