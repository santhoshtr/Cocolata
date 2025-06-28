input glyph;
beginglyph;
z0 = (x1 - Xw/8, 0.9X);
z1 = (x2 - Xw/8, y2 + s/3);
z2 = (Xw/4, y0/2);
paths[0] = z0{right}..z1{dir -100}..{right}z2;

z3 = (x2 - Xw/8, y2 - s/3);
z4 = (x0, 0);

paths[1] = z2{left}..z3{dir -800}..{left}z4;

pen_stroke(
    nib(thicknib)(0,1,2)
)(paths[0])(strokes[0]);

pen_stroke(
    nib(thicknib)(0,1,2)
)(paths[1])(strokes[1]);

lbearing:=lbearing*1.5;
rbearing:=rbearing*1.5;
endglyph;

