input glyph;
beginglyph;
input ./glyphs/include/left_arch;

paths[p] := paths[p] shifted (mw/3,0);
strokes[p] := strokes[p] shifted (mw/3,0);


p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0+mw/3 , 0.9m);
z2 = ( x1+mw/3 , (y1+y3)/2.5);
z3 = ( x0,  reph_sign_depth);
z4 = ( 0,  m/2);
z5 = ( xpart point 1 of paths[p-1],  m);

paths[p]= z0{up}..z1{dir 20}..z2..z3..z4..z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2, 3,4,5)
)(paths[p])(strokes[p]);


anchor( "right", point 2.6 of paths[p]);

endglyph;
