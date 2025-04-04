input glyph;
beginglyph;
z0 = (0, 0.85X);
z1 =  (z0 +z2)/2;
z2 =(0.5Xw, X);
paths[p] = z0{dir 80}..{dir -30}z1..{dir 80}z2;
pen_stroke(
     nib(thicknib)(0,1,2 )
)(paths[p])(strokes[p]);
anchor( "top", (xpart(point 1 of paths[p]), ypart(point 0 of paths[p])));
endglyph;
