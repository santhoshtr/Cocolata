% Avagraha
input glyph;
beginglyph;

z0 = (x1+mw/4, m);
z1 = ((x0+x2)/2, 1.25m);
z2 = (mw/2, (y1+y3)/2);
z3 = ((x2+x4)/2, -descent*0.75);
z4 = (0, 0);
paths[0] = z0..z1...z2{down}...z3{left}..{up}z4;

pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[0])(strokes[0]);
endglyph;
