input glyph;
beginglyph;


z0=(0, 0.95X);
z1=(x0 , 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-1]- 0.2X, 0.95X);
z1=(x0 + 0.4X, X);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-2]- 0.2X, 0);
z1=(x0 + 0.4X, y0);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


anchor( "top", (xpart(point 0 of paths[0]), 1.2X));
endglyph;
