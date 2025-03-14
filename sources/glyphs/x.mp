input glyph;
beginglyph;
z0=(0, 0.9s);
z1=(x0 + 0.45sw, 0.5(y0+y2));
z2=(x0, 0.1s);

paths[p] = z0{dir -30}...z1...{dir 210}z2;
pen_stroke(
     nib(thicknib)(0, 1, 2, 3 )
)(paths[0])(strokes[0]);

clearxy;
p:=p+1;
z0=(0.85sw, ypart point 0 of paths[p-1]);
z1 = point 1 of paths[p-1];
z2=(x0,  ypart point 2 of paths[p-1]);

paths[p] = z0{dir 210}...z1...{dir -30}z2;
pen_stroke(
     nib(thicknib)(0, 1, 2, 3 )
)(paths[p])(strokes[p]);


endglyph;
