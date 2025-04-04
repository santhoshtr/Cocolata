
input glyph;
beginglyph
clearxy;
z0= (x2 + 0.2mw , (y1+y3)/1.85);
z1 = (x0 + 0.1mw, 1.1m); % bottom of loop
z2 = ( 0, 1.25m);
z3 = ( x4 - mw/4, X); % top
z4 = ( x2 + 0.8mw, 1.1m);
z5 = ( x4 , -0.2m);

paths[p]:=z0 ..z1...z2{dir 60} ...z3..z4{down}..z5   ;

% paths[p] :=harmonize(paths[p]);
paths[0] := paths[0] shifted (-x4 + 2/3thick  , 0);
pen_stroke(
    nib(thicknib scaled 0.8)(0,1)
    nib(thicknib scaled 0.9)(2)
    nib(thicknib)(3,4,5)
)(paths[p])(strokes[p]);

absolute_position := 1;
endglyph;
