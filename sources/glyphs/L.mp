input glyph;
beginglyph;

z0=(0, X);
z1=(x0 ,  0);
z2=(x0+0.75mw ,  0);
paths[p] := z0{dir -80}..{down}z1{dir 10}..z2;

pen_stroke(
   nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);


anchor( "top", (xpart(point 0 of paths[0]), 1.2X));
anchor( "bottom", (xpart(point 0.5 of paths[0]), 0));
endglyph;
