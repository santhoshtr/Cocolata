input glyph;
beginglyph;

input ./glyphs/include/ച;

% Shoe
clearxy;
p:=p+1;
z0 = point 3.75 of paths[p-1];
z1 = (xpart point 1 of paths[p-1], -descent*0.75) ;
z2 = (xpart(point 4 of paths[p-1]), y1) ;
paths[p] := z0 ..{left}z1{right}...{right}z2{up}..{up}(point 4 of paths[p-1]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1,2,3)
)(paths[p])(strokes[p]);


lbearing:=0;

anchor( "vc", point 2 of paths[0]);
anchor( "right", point 2 of paths[p] - (mw/5, 0));
endglyph;
