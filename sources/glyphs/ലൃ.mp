input glyph;
beginglyph;

input ./glyphs/include/ല;


p:=p+1;
clearxy;

z0 = point 7 of paths[p-1];
z1 = ((x0 + x2)/2, -0.8descent);
z2 = (x0 - 0.67mw, y1 + m/4);
z3 = ((x0 + x1)/2, y2);
paths[p] =  z0{dir -80}.. {dir 190}z1..z2.. {dir -45}z3;
pen_stroke(
    nib(thicknib  )(0)
    nib(thicknib)(1,2,3,4,5,6)
)(paths[p])(strokes[p]);


endglyph;