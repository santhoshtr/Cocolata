input glyph;
beginglyph;
z0=(x2 + sw/2, 0.9X);
z1=((x0+x2)/2, X);
z2=(x3  , 0.8X);
z3=(sw/4, undershoot);
paths[p] = z0..z1..z2 ..{dir -80}z3;
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

%bar
clearxy;
p:=p+1;
z0 = (0, 0.9s);
z1 = (x0 + 0.5sw, y0);
paths[p] = z0{dir 5}..z1;
pen_stroke(
    nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

endglyph;
