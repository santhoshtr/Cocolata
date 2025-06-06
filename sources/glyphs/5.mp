input glyph;
beginglyph;
z0=(0.05Xw , 0.75X);
z1=(x0 + .45Xw, 0.8X  );
paths[0] = z0{dir -5}..z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 0 of paths[0]+thin/2, ypart point 0 of strokes[0]-thick/2);
z1=(0, 0.5s);

paths[p] = z0{down}..z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-1], ypart point 1 of paths[p-1]);
z1=(x0 + sw/3, y0+ s/4);
z2=(x1 + 0.4sw, (y1  + y3)/2);
z3=(x2 - sw/3, undershoot);
z4=(0, m/6);
paths[p] = z0{dir 60}..z1..z2..z3..z4;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib rotated terminalangle 4 of paths[p])(4)
)(paths[p])(strokes[p]);

endglyph;
