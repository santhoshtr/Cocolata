input glyph;
beginglyph;

% The strokes of I
z0=(0, 0.9X);
z1=(x0 , 0.05X);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-1]- 0.2X, 0.9X);
z1=(x0 + 0.4X, 0.95X);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 1 of paths[p-2]- 0.2X, 0);
z1=(x0 + 0.4X, 0.05X);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% The stroke of J, at the right of I
clearxy;
p:=p+1;
z0=(x3, X);
z1=(x2, X);
z2=(x3 + 0.4sw , undershoot);
z3=(0, y2 + s/4);
paths[p] = z0...{dir -10}z1{dir -80}...z2..{up}z3;
paths[p] := paths[p] shifted (0.3X, 0);
pen_stroke(
     nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

endglyph;
