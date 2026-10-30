% The stroke of j, without the dot
z1=(x2, s-overshoot);
z2=(x3 + 0.4sw, 0.8*-descent);
z3=(-0.2sw, y2 + s/4);
paths[p] = z1{dir -80}...z2..{up}z3;
pen_stroke(
   nib(thicknib)(0, 1, 2)
)(paths[p])(strokes[p]);
