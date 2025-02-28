input glyph;
beginglyph;
clearxy;
input ./glyphs/include/left_arch_with_eye;

clearxy;
p:=p+1;
z0=point infinity of paths[p-1] ;
z1=(x0 + mw/3, 0.9m);
z2=(x1 + mw/3, 0.5m);
z3=(x0 - mw/4, -descent/2);
z4=(x2+thick, y3);
paths[p] = z0{up}..{dir 20}z1..z2..{left}z3{right}..z4 ;
pen_stroke(
     nib(thicknib)(0,1,2, 3)
     nib(thicknib scaled 1.2)(4)
)(paths[p])(strokes[p]);

endglyph;
