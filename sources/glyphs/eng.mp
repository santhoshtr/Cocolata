input glyph;
beginglyph;

% The strokes of n. The right leg continues below the baseline as a hook.
z0=(0, s-overshoot);
z1=(x0+0.1sw, undershoot);
paths[p] := z0{dir -60}..{dir -90}z1;
pen_stroke(
     nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=point infinity of paths[p-1];
z1=(0.67(x0+x2), 0.9s);
z2=(x0 + 0.7sw, 0);
z3=(x2 - s/3, -descent*0.9);
paths[p] := z0{dir 70}...{dir 20}z1{dir -60}..{down}z2..{dir 160}z3;
pen_stroke(
   nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

rbearing:=rbearing/2;
endglyph;
