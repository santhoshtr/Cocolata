input glyph;
beginglyph;

% The strokes of H
z0=(0, X);
z1=(x0 , undershoot);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(0.5Xw, 0.95X);
z1=(x0 , 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=point 4.5 of strokes[p-2];
z1=(x0+ 0.6sw, y0);
paths[p] = z0{dir 10}..z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Bar, across both stems above the cross bar
clearxy;
p:=p+1;
z0=point 0.25 of paths[0] - (sw/4, 0);
z1=(xpart point 0.25 of paths[1] + sw/4, y0);
paths[p] = z0--z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 0.5 of paths[2]), 1.1X));
endglyph;
