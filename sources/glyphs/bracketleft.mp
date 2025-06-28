input glyph;
beginglyph;
z0= (x1 + sw/2, 0.9X);
z1=( 0, y0-thin);
z2=( x1, 0);
z3=( x0, y2+thin/2);
paths[0] = z0..{left}z1{dir -75}...{dir -105}z2{right}...z3 ;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[0])(strokes[0]);
lbearing:=lbearing*1.5;
rbearing:=rbearing*1.5;
endglyph;
