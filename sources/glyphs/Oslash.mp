input glyph;
beginglyph;
z0=(0, X/2);
z1=(x0 + 0.4Xw, y0 + 0.5X - thick/4);
z2=(x1 + 0.4Xw, y0);
z3=(x1, undershoot);
z4=(x0, y0);

paths[0] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;

pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4)
)(paths[0])(strokes[0]);

clearxy;
% A steep slash, about 75 degrees as in slash.mp. A less steep slash is
% almost perpendicular to the nib, and becomes heavier than the bowl.
z0= (xpart(point 1 of paths[0]) + 0.14X, X);
z1=( xpart(point 1 of paths[0]) - 0.14X, -X*0.05);

paths[1] = z0--z1 ;


pen_stroke(
    nib(thicknib)(0, 1)
)(paths[1])(strokes[1]);

endglyph;
