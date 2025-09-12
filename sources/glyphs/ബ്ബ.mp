input glyph;
beginglyph;

input ./glyphs/include/ബ;

% Shoe
clearxy;
p:=p+1;
z0 = point 3.5 of paths[p-1];
z1 = (xpart point 3 of paths[p-1], -descent*0.75) ;
z2 = (xpart(point 8 of paths[p-1]), y1) ;
z3 = (xpart(point 8 of paths[p-1]), 0) ;
paths[p] := z0 ..{left}z1{right}...{right}z2{up}..{up}z3;
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 5 of paths[0]),0));
anchor( "right", point 2 of paths[p]);
endglyph;
