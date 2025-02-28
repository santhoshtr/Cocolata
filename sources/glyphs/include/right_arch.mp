clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0+mw/3 , 0.9m);
z2 = ( x1+mw/3 , y0);
z3 = ( x2 - 0.1mw, 0);
paths[p]= z0{up}..z1{dir 20}..z2..z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);