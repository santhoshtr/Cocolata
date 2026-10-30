input glyph;
beginglyph;
clearxy;
z0 =(thick, (y1 + y3)/1.5);
z1 =(x0 + mw/5, y3+0.5m);
z2=(x1 + mw/5, (y1 + y3)/2);
z3=(x2 - mw/5, undershoot);
z4=(0, (y3 + y5)/2);
z5=(x4 + mw/2, 0.9m);
z6=(x5 + mw/2, (y5+y7)/2);
z7=(x6- mw/4, undershoot);
z8=(x6 + mw/3, y7);
z9=(x8, 1.2m);
paths[p] := z0{dir 80}..z1..z2..z3..z4..z5 ..z6
..{left}z7{right}..{right}z8{dir 100}..{dir 80}z9;
pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
paths[p] = vocalic_r_sign shifted (xpart point infinity of paths[p-1], 0);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

endglyph;
