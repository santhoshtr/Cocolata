input glyph;
beginglyph;
z0= (x2+ 2/3Xw, 0.5X);
z1 =((x0+x2)/2.5, undershoot);
z2 =(0, (y1+y3)/2);
z3 =(0.8x1, 0.55X);

paths[p] =z0..z1{left}..z2{up}..z3 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);
p:=p+1;

clearxy;
z0 =(Xw/2, 0.9X);
z6 =(0.25x0, 0.9y0);
z7 =(0.5x0, 0.6y0);
z8 =(1.5x0, 0);
paths[p] =z0 ..z6..z7---z8;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

endglyph;
