input glyph;
beginglyph;

z0=(0, X);
z1=(x0 ,  0);
paths[p] := z0{dir -80}..z1;
pen_stroke(
   nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);

lbearing:=sw/3*0.2;
rbearing:=sw/3*0.2;
anchor( "top", (xpart(point 0 of paths[0]), 1.2X));
endglyph;
