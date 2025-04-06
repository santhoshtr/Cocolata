input glyph;
beginglyph;

z0=(mw/6, 0.8X);
z1=(x0 , .1X);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(0, 0.8X);
z1=(x0 + 0.3Xw, 0.95X);
z2=(x0 + 0.5Xw, 1.1s);
z3=point 0.4 of paths[p-1];
z4=(x0+0.5Xw, (y3+y5)/2.5);
z5=(x0, undershoot);
paths[p] = z0{dir 60}..z1..z2{dir 260}..{dir 180}z3{dir -10}..z4...{dir 180}z5;
pen_stroke(
   nib(thicknib)(0,1,2,3)
   nib(thicknib rotated 30)(4,5)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
