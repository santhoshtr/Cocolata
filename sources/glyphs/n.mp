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
z1=(0.5(x0+x2), 0.85s);
z2=(x0 + 0.7sw, undershoot);
paths[p] := z0{dir 80}...z1...{dir -80}z2;
% paths[p] :=  harmonize(paths[p] );
pen_stroke(
   nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);


anchor( "top", (xpart(point 1 of paths[1]), 1.2s));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
