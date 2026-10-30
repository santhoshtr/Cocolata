input glyph;
beginglyph;
save r;
r=0.8;
z0 = (0, s/2);
z1 = (x0 + r*sw/2, s - overshoot);
z2 = (x1 + r*sw/2, y0);
z3 = (x2 - r*sw/2, undershoot);
z4 = (x0, y0);
paths[0]:=  z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;

pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[0])(strokes[0]);
clearxy;
% A steep slash, about 75 degrees as in slash.mp. A less steep slash is
% almost perpendicular to the nib, and becomes heavier than the bowl.
z0= (xpart(point 1 of paths[0]) + 0.11X, X*0.8);
z1=( xpart(point 1 of paths[0]) - 0.11X, -X*0.05);

paths[1] = z0--z1;

pen_stroke(
    nib(thicknib)(0, 1)
)(paths[1])(strokes[1]);

endglyph;
