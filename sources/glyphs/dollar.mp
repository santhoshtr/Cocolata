input glyph;
beginglyph;

z0 = (x6 + 0.5Xw, 0.7X);
z1 = (x0 - 0.05Xw, 0.85X);
z2 = (x1 - Xw/2, 0.7X);
z3 = (x2 + 0.25Xw, 0.5X);
z4 = (x1, 0.4X);
z5 = (x4 + 0.1Xw, 0.1X);
z6 = (0, 0.1X);


paths[p] = z0..{dir 140}z1{dir 190}...{dir 210}z2...{dir -30}z3...z4{dir -30}...{dir 210}z5...z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0,1 ,2,3,4,5,6)
)(paths[p])(strokes[p]);

% bar
p:=p+1;
clearxy;
z0=(xpart(point 1.35 of paths[0]) , X);
z1=(x0, -0.2s);
paths[p]=z0---z1;
pen_stroke(
    nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


endglyph;
