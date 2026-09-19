input glyph;
beginglyph;

z0=(0.2u, 0.85X);
z1=(x0 , 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(0, 0.9X);
z1=(x0 + 0.3X, 0.95X);
z2=(x0 + 0.5X, s);
z3=(x0+0.15sw, 0.6s);
z4=(x2, undershoot);
paths[p] = z0{dir 20}..z1..z2{dir 260}..{dir 190}z3{dir -15}..z4;
pen_stroke(
   nib(thicknib)(0,1,2,3)
   nib(thicknib rotated 20)(4)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
