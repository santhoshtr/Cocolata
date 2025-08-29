input glyph;
beginglyph;
% f
z0=(x2 + sw/2, 0.9X);
z1=((x0+x2)/2, X);
z2=(x3  , 0.8X);
z3=(sw/4, undershoot);
paths[p] = z0..z1..z2 ..{dir -80}z3;
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

%f
clearxy;
p:=p+1;
z0=(x2 + sw/2, 0.9X);
z1=((x0+x2)/2, X);
z2=(x3  , 0.8X);
z3=(sw, undershoot);
paths[p] = z0..z1..z2 ..{dir -80}z3;
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);
%bar

clearxy;
p:=p+1;
z0 =(0, 0.9s);
z1 = (xpart point 0 of paths[p-1], s);
paths[p] = z0{dir 10}.. z1;
pen_stroke(
     nib(thicknib rotated 10)(0,1)
)(paths[p])(strokes[p]);

endglyph;
