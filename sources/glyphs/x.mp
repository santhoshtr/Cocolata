input glyph;
beginglyph;
z0=(0, s-overshoot);
z1=(x0 + 0.45sw, 0.5s);
z2=(x0, undershoot);

paths[p] = z0{dir -30}...z1..{dir 210}z2;
pen_stroke(
     nib(thicknib)(0, 1, 2, 3 )
)(paths[0])(strokes[0]);

clearxy;
p:=p+1;
z0=(0.85sw, s-overshoot);
z1 = point 1 of paths[p-1];
z2=(x0, undershoot);

paths[p] = z0{dir 220}...z1..{dir -20}z2;
pen_stroke(
     nib(thicknib)(0, 1, 2, 3 )
)(paths[p])(strokes[p]);


endglyph;
