input glyph;
beginglyph;
z0= (0, 0.95X);
z1=( x0, 0.1s);
z2=( x1 + 0.5Xw , y1);
paths[p] = z0{dir 260}...z1{right}..{right}z2 ;
pen_stroke(
   nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=point 0 of paths[p-1] - (0.2u,0.2u) ;
z1=(x0 + 0.5Xw, y0);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0= point 0 of strokes[p-2]- (-thick/2, 0.5X);
z1=(x0 + 0.4Xw, y0);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0.5 of paths[1]), 1.2X));
endglyph;
