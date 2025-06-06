input glyph;
beginglyph;


z0=(0, s);
z1=(x0 , undershoot);
paths[p] := z0{dir -100}..{dir -80} z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


p:=p+1;
clearxy;
z0=(xpart point 1 of strokes[p-1], 0.9X);
z1=(x0+0.05s, y0-0.08X);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib rotated 30)(0,1)
)(paths[p])(strokes[p]);


endglyph;
