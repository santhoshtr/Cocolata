input glyph;
beginglyph;

z0 = (x6 + 0.6sw, 0.8s);
z1 = (x0 - 0.05sw, 0.9s);
z2 = (x1 - sw/2, 0.75s);
z3 = (x2 + 0.3sw, 0.5s);
z4 = (x1, 0.4s);
z5 = (x4 + 0.2sw, 0.1s);
z6 = (0, 0.1s);


paths[p] = z1{dir 190}..{dir 210}z2..{dir -30}z3...z4{dir -30}...{dir 210}z5...z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0,1 ,2,3,4,5,6)
)(paths[p])(strokes[p]);


lbearing:=thick*condense*0.4;
rbearing:=thick*condense*0.4;
anchor( "top", (xpart(point 1 of paths[0]), 1.2s));
anchor( "bottom", (xpart(point 1 of paths[0]), 0));
endglyph;
