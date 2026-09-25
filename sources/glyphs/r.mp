input glyph;
beginglyph;

z0=(0, s-overshoot);
z1=(x0+0.1sw, undershoot);
paths[p] := z0{dir -60}...{dir -90}z1;
pen_stroke(
     nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=point infinity of paths[p-1];
z1=(x0+0.4sw, 0.9s);
z2=(x1 + 0.1sw, 0.7s);
paths[p] := z0{dir 80}...{dir 20}z1{dir -60}..z2;
%  paths[p] :=  harmonize(paths[p] );
pen_stroke(
   nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);

rbearing:=rbearing/2;

anchor( "top", (xpart(point 1 of paths[1]), 1.2s));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
