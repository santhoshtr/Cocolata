input glyph;
beginglyph;

input ./glyphs/include/left_arch;

clearxy;
p:=p+1;
z0 =  point infinity of paths[p-1] ;
z1 = ( x0+mw/3  , 0.9m);
z2 = ( x1 + mw/2, y0);
z3 = ( x0, -0.8descent);
z4 = ( x3 - mw/3, y3 + m/4);
z5 = ( x1, y4);

paths[p]:=z0{up}
    ..z1{dir 10}..z2{down}..z3..z4..{dir -40}z5 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2,3,4,5)
)(paths[p])(strokes[p]);

endglyph;
