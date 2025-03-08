input glyph;
beginglyph;

z0=(0, X+serif_height);
z1=(x0, undershoot);
paths[p] := z0{dir -100}..{down}z1;
pen_stroke(
  nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);

p:=p+1;
paths[p] := n_arch shifted(xpart(point 0 of paths[p-1]),0);
pen_stroke(
    nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);


endglyph;
