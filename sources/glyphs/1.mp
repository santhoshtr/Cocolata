input glyph;
beginglyph;

clearxy;

z0=(0,0.95X);
z1=(x0, 0);
paths[p]  = z0{dir 280}..z1 ;
pen_stroke(
  nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);

endglyph;
