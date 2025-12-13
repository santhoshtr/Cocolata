input glyph;
beginglyph
clearxy;
z0= (mw/4, (y2+y4)/2);
z1= ((x3 + x5)/2, (y0 + y2)/2);
z2 = (x4, m); % bottom of loop
z3 = ( x0, y1);
z4 = ( (x3 + x5)/2.5, X); % top
z5 = ( x0 + 0.6mw, m);
z6 = ( x5 , -0.1m);

paths[p]:=z0..z1..z2 ..z3...z4..{dir 275}z5..z6;

paths[p] :=harmonize(paths[p]);
paths[0] := paths[0] shifted (-x1 + 2/3thick  , 0);
pen_stroke(
    nib(thicknib scaled 0.8)(0,1)
    nib(thicknib)(2,3,4,5)
    nib(thicknib rotated 10)(6)
)(paths[p])(strokes[p]);
absolute_position := 1;
endglyph;
