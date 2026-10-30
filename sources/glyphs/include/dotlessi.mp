% The stem of i, without the dot
z0=(0, s);
z1=(x0, undershoot);
paths[p] := z0{dir -100}..{dir -80}z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);
