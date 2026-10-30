input glyph;
beginglyph;
z0=(0.06Xw , 0.89X);
z1=(x0 + .53Xw, 0.95X  );
paths[0] = z0{dir -5}..z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 0 of paths[0]+thin/2, ypart point 0 of strokes[0]-thick/2);
z1=(0, 0.59s);

paths[p] = z0{down}..z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-1], ypart point 1 of paths[p-1]);
z1=(x0 + 0.4sw, y0+ 0.3s);
z2=(x1 + 0.48sw, (y1  + y3)/2);
z3=(x2 - 0.4sw, undershoot);
z4=(0, 0.2m);
paths[p] = z0{dir 60}..z1..z2..z3..z4;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib rotated terminalangle 4 of paths[p])(4)
)(paths[p])(strokes[p]);

endglyph;
