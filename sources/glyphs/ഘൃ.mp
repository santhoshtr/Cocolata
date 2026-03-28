input glyph;
beginglyph;
clearxy;
z0= (0, 0.45m);
z1= (x0+mw/4, y0+0.4m);
z2 = (x0+mw/2, y0);
z3 = (x1 + thick, y0);
z4 = ( x2 + 0.9mw , y3);
z5 = ( x4 - mw/4, m);
z6 = ( (x3+x4)/2, 0.5m);
z7 = (x4, 0.1m);
z8 = (x7+mw/2, 0.9m);


paths[p]:=z0{dir 90}..z1..{dir 200}z3{right}..{dir 10}z4{dir 10}
..z5{left}..{dir 290}z6 ..z7 ..{dir 100}z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7,8)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0 = (0, ypart point 3.3 of paths[p-1]);
z1 = ((x0 + x2)/2, -0.9descent);
z2 = (x0 -0.67mw, y1 + m/4);
z3 = ((x0 + x1)/3, y2);
paths[p] :=     z0{dir 280}.. {dir 190}z1..z2.. {dir -45}z3;
paths[p] := paths[p] shifted (xpart point infinity of paths[p-1], 0);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);

endglyph;
