input glyph;
beginglyph;
z0=(x1 + mw/6, y4);
z1=(x2 - mw/5, y3);
z2=((x1 +x3)/2, y3- m/5);
z3=(x4 + mw/3, (y4+y2)/2);
z4=(x5 + mw/2, m);
z5=(0, (y4 + y6)/2);
z6=(x4, thick*0.77/4);
z7=(x3, (y6+y8)/2);
z8=(x2, y7+m/5);
z9=(x1, y7);
z10=(x0, y6);
paths[p] =z0{dir 200}.. z1..z2{right}.. z3..z4{left} ..z5{down}.. z6{right} ..z7..z8..z9..{dir -20}z10;

pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;

input ./glyphs/include/ാ;

paths[p] := paths[p]  shifted(xpart(point 3 of paths[p-1]) + mw/4, 0);
strokes[p] := strokes[p]  shifted(xpart(point 3 of paths[p-1]) + mw/4, 0);


endglyph;
