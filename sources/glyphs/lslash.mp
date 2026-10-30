input glyph;
beginglyph;

% The stroke of l
z0=(0, X);
z1=(x0, 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Slash, across the middle of the stem
clearxy;
p:=p+1;
z0=point 0.5 of paths[0] - (sw/4, s/8);
z1=point 0.5 of paths[0] + (sw/4, s/8);
paths[p]=z0--z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);
endglyph;
