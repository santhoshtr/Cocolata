input glyph;
beginglyph;
z0 = (0, y1-0.3s);
z1 = (x0+ Xw/6, 1.1s);
z2 = (x1+ Xw/5, y0);
z3 = (x0+ Xw/5, X/4);

paths[p] := z0..z1{dir 10}..z2..{dir -80}z3;

pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
soften:=0;
paths[p] = circle(thick*1.5) yscaled 0.8 shifted(xpart point 3 of strokes[p-1], 0);
strokes[p] = paths[p];

endglyph;
