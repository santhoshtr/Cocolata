input glyph;
beginglyph;

z0 = (x4, y1 - s/4.5);
z1 = ((x0+x2)/2, s-overshoot);
z2 = (x6+ thick/2, (y1 +y3)/2);
z3 = ((x2 + x4)/2, (y2 + y4)/2);
z4 = (0.7sw, (y3 + y5)/2);
z5 = ((x4 + x6)/1.8, undershoot);
z6 = (0, y5+s/4);

paths[p] = z0   ..z1 ..z2  ..z3..z4..z5  ..  z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0,1 ,2,3,4,5,6)
)(paths[p])(strokes[p]);


lbearing:=thick*condense*0.4;
rbearing:=thick*condense*0.4;
anchor( "top", (xpart(point 1 of paths[0]), 1.2s));
anchor( "bottom", (xpart(point 1 of paths[0]), 0));
endglyph;
