clearxy;
z0 = point infinity of paths[p-1];
z1=((x0+x2)/2, 0.8m); % Top of arch
x2-x0 = 0.6mw;
z2=(x2, y0);

paths[p] =  z0{up}..{dir 20}z1..{down}z2;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);
