input glyph;
beginglyph;

input ./glyphs/include/left_arch;


p:=p+1;
clearxy;
z0= point infinity of paths[p-1];
z1 = ( (x0 + x2)/2, 0.9m); % top
z2 = ( x0 +  0.8mw, (y1+y3)/1.6);
z3 = ( x1, 0); % bottom middle
z4 = ( x2 + mw/3, y3);
paths[p]:=z0..z1{dir 20}..z2..{left}z3{right}..{right}z4;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib scaled 1.1 )(6)
)(paths[p])(strokes[p]);

endglyph;
