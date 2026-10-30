input glyph;
beginglyph;
z0 = (sw/3, undershoot);
z1 = (x0 , y0 - m/6 - thick/2);

z2 = (x1  , y1 + thin/2);
z3 = (x2 + sw/3, (y2 +y4)/1.5);
z4 = (x2-thick, -descent*0.8);

paths[p] = z0 -- z1;
paths[p] := paths[p] crotated -20;

pen_stroke(
    nib(thicknib scaled 0.8)(0, infinity)
)(paths[p])(strokes[p]);
p:=p+1;
paths[p] = z2{right}..z3{down}..{dir 120}z4;
pen_stroke(
    nib(thicknib scaled 0.8)(0, 1, 2)
)(paths[p])(strokes[p]);
anchor( "bottom", (xpart(point 0 of paths[p]), undershoot));
endglyph;
