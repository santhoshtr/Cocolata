input glyph;
beginglyph;
z0=( 0, y1-thin);
z1= (x0 + sw/2, 0.9X);
z2=( x1, 0);
z3=( x0, y2+thin/2);
paths[p] = z0..{dir 0}z1{dir -98}...{dir -80}z2{left}...z3 ;
pen_stroke(
    nib(thicknib)(0, 2, 3)
    nib(thicknib rotated 20)( 1)
)(paths[p])(strokes[p]);

lbearing:=lbearing*1.5;
rbearing:=rbearing*1.5;
endglyph;
