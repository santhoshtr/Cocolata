input glyph;
beginglyph;

z0=(0, s);
z1=(x0 , -descent);
paths[p] := z0{dir -80}...{dir -100}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=point 0.6 of paths[p-1];
z1=(x0 + 0.4s, 0.95s);
z2=(x0 + 0.67s, 0.5s);
z3=(x0+0.1sw, 0.1s);

paths[p] = z0{dir 80}..z1..z2{dir 260}..{dir 160}z3;
pen_stroke(
   nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
