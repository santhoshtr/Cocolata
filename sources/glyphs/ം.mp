input glyph;
beginglyph;

r:=0.3;
z0=(0, y3+r*m);
z1=((x2+x0)/1.8, y0 +0.8r*m);
z2=(x1 + 0.8r*mw, y0);
z3=(x1, 2undershoot);
z4=(x0, y0);

paths[0] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib )(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.3)(3)
    nib(thicknib)(4)
)(paths[0])(strokes[0]);

endglyph;
