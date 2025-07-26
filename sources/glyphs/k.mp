input glyph;
beginglyph;

z0=(0, X);
z1=(x0 , 0);
z2=(x1+ 0.5sw, 0.9s);
z3=(x2,0);
paths[p] := z0{dir -100}..{down}z1{dir 60}..{dir 30}z2{dir 210}..{dir -35}z3;
pen_stroke(
   nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0 of paths[0]), 1.2X));
endglyph;

