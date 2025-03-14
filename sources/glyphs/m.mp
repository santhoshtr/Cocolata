input glyph;
beginglyph;

z0=(0, s-overshoot);
z1=(x0+0.1sw, undershoot);
paths[p] := z0{dir -80}..z1;
pen_stroke(
     nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

% m has two condensed n archs
p:=p+1;
clearxy;
z0=point infinity of paths[p-1];
z1=(0.5*x2, 0.85s);
z2=(x0 + 0.7sw, undershoot);
z3=(x2 + 0.33sw, 0.8s);
z4=(x2 + 0.7sw, undershoot);
paths[p] := z0{dir 80}..{dir 40}z1..{dir -90}z2{dir 80}..{dir 40}z3..{dir -100}z4;
% paths[p] :=  harmonize(paths[p] );
pen_stroke(
   nib(thicknib)(0,1,2, 3,4)
)(paths[p])(strokes[p]);

endglyph;
