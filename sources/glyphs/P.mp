input glyph;
beginglyph;

z0=(0, X);
z1=(x0 , 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-1], 0.8X);
z1=(x0 + 0.3X, 0.95X);
z2=(x0 + 0.5X, s);
z3=(x0+0.1sw, 0.5s);

paths[p] = z0{dir 60}..z1..z2{dir 260}..{dir 190}z3;
pen_stroke(
   nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);


anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
