input glyph;
beginglyph;

z0=(0, X);
z1=(x0 , 0);
paths[p] := z0{dir -100}..{down}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(0.5sw, 0.9s);
z1 = point 0.7 of paths[p-1];
z2=(x0+0.1sw, undershoot);

paths[p] = z0{dir 245}..{dir 215}z1{dir -40}..{dir -30}z2;
pen_stroke(
     nib(thicknib)(0, 1, 2, 3 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0 of paths[0]), 1.2X));
endglyph;
