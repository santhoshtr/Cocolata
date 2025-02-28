input glyph;
beginglyph;
z0=(x1 + mw/6, 0.9m);
z1=(0, 0);
z2=(x1+mw, y1);
paths[p] = z0..{dir 250}z1{dir 0}..z2;

pen_stroke(
     nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=(xpart point 1.5 of paths[p-1], 0);
z1=(x0, -descent);
paths[p]  = z0--z1 ;
pen_stroke(
  nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);

endglyph;