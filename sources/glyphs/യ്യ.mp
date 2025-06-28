input glyph;

beginglyph;
input ./glyphs/include/യ;

% Shoe
clearxy;
p:=p+1;
z0 = point 7 of paths[p-1];
z1 = (xpart point 3 of paths[p-1], -descent*0.75) ;
z2 = (xpart(point 8 of paths[p-1]), y1) ;
z3 = (xpart(point 8 of paths[p-1]), 0) ;
paths[p] := z0 ..{dir 180}z1--z2--z3;
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart point 0 of paths[0],0));
anchor( "right", point 2 of paths[p]);

endglyph;

