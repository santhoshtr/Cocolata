input glyph;
beginglyph;


z0=(0, X);
z1=(x0 , 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=point 5 of strokes[p-1];
z1=(x0+ 0.6sw, y0);
paths[p] = z0{dir 10}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=point 4.55 of strokes[p-2];
z1=(x0+sw/2, y0);
paths[p] = z0{dir 5}..z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

endglyph;
