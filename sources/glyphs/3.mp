input glyph;
beginglyph;


p:=p+1;
z0=(0, 1.19s);
z1=(x0 + 0.42sw, 0.95X);
z2=(x0 + 0.65sw, 0.83X);
z3=(x0+0.12sw, 0.48X);
z4=(x0+0.71sw, (y3+y5)/2.5);
z5=(x0 - lbearing, 0.24s);
paths[p] = z0{dir 90}..z1..z2...{dir 180}z3{dir -10}..z4...{dir 135}z5;
pen_stroke(
   nib(thicknib)(0,1,2,3,4,5)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
