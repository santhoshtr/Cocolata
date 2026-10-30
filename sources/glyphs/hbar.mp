input glyph;
beginglyph;

% The strokes of h
z0=(0, X-overshoot);
z1=(x0 + 0.1sw, undershoot);
paths[p] := z0{dir -60}...{dir -90}z1;
pen_stroke(
     nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=point infinity of paths[p-1];
z1=(0.67(x0+x2), 0.9s);
z2=(x0 + 0.7sw, undershoot);
paths[p] := z0{dir 70}...{dir 20}z1{dir -60}..{dir -60}z2;
pen_stroke(
   nib(thicknib)(0, 1, 2)
)(paths[p])(strokes[p]);

% Bar, across the stem above the x-height
p:=p+1;
clearxy;
z0=point 0.2 of paths[0] - (sw/4, 0);
z1=(x0 + 0.75sw, y0);
paths[p]=z0--z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

rbearing:=rbearing/2;

endglyph;
