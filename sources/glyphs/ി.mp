
input glyph;
beginglyph
clearxy;
z0= (0, 1.1m);
z1 = ( (x0 + x3)/1.25, X); % top
z2 = ( x0 + 0.9mw, y0);
z3 = ( x2 , -0.2m);

paths[p]:=z0{dir 70}..z1..{down}z2{down}...z3;

paths[p] :=harmonize(paths[p]);
paths[0] := paths[0] shifted (-x3 + 2/3thick , 0);
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);
absolute_position := 1;
endglyph;

