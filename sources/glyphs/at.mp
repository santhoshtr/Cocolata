input glyph;
beginglyph;

paths[0] := a_loop shifted (sw/3, 0);

pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[0])(strokes[0]);


clearxy;
p:=p+1;
z0=(xpart point 0 of paths[p-1], s);
z1=(x0, 0.2s);
z2=((x1+x3)/2, 0);
z3=(x2+sw/4, y1);
z4=(x3, (y3+y5)/2);
z5=((x4+x6)/2, 1.3s);
z6=(xpart point 2 of paths[p-1]-sw/2, s/2);
z7=(x5+sw/4, -0.3s);
paths[p] := z0---z1..z2..z3..z4..{left}z5..{down}z6..{dir 20}z7;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), X));
endglyph;