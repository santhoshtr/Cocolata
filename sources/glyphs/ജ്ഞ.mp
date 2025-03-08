input glyph;
beginglyph;
clearxy;
input ./glyphs/include/left_arch_with_eye;

clearxy;
p:=p+1;
z0=point infinity of paths[p-1] ;
z1=(x0 + mw/3, 0.9m);
z2=(x1 + mw/3, 0.45m);
z3=(x0 - mw/4, -descent/3);
z4=(x2 , 0);
z5 = (x4, y3);
z6 = (x4 - mw/3, y4);
z7 = (x4 + mw/3, y5);
paths[p] = z0{up}..{dir 20}z1..z2..{dir 220}z3{dir 30}..z4
     ..z5..z6..{down}z7;
paths[p]:=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2, 3,4,5,6,7)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
input ./glyphs/include/_ത;
anchor( "vc", point infinity of paths[0]);

endglyph;
