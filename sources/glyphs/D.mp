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
z0=(xpart point 1 of paths[p-1], X);
z1=(x0 + 0.5Xw, 0.5X);
z2=(x0 + 0.4Xw, 0.2s );
z3=(x0+0.1sw, 0);

paths[p] = z0{dir -20}..z1..z2..z3;
pen_stroke(
   nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
