input glyph;
beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
radius:=0.2sw;
z0=(0, 0.95X);
z1=(x0 + radius, y0 + radius);
z2=(x1 + radius, y1 - radius);
z3=(x2 - radius, y2 - radius);
z4=(x3 - radius, y3 + radius);

paths[0] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
pen_stroke(
   nib(thicknib scaled 3/4)(0, 1, 2, 3, 4)
)(paths[0])(strokes[0]);
anchor( "top", point 3 of paths[0]);
endglyph;
