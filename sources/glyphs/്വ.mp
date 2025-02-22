input glyph;
beginglyph;

z0 = (0, -m/4);
z1 = (x0 + mw/2 , y0);
z2 = (x1, 0.8m);

paths[p]:=z0..{dir -10}z1{dir 100}..z2  ;
paths[p]:=harmonize(paths[p]);
paths[p] := paths[p] shifted (-x1 + 2/3thick , 0);

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
)(paths[p])(strokes[p]);

absolute_position := 1;
endglyph;
