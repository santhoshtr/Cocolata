input glyph;
beginglyph;
input ./glyphs/include/left_arch;

p:=p+1;
clearxy;
z0= point infinity of paths[p-1];
z1=(x0, m*0.6);
z2=(x1+mw/3, 0.9m); % Top of arch
z3=(x2+mw/2, 0.4m);
z4= (x3 - mw/4,thin/2);
z5= (x4 - mw/4, (y4 + y7)/3);
z6= (x5 + mw/3, (y5+y7)/2);
z7= (x3 + mw/3, m);

paths[p] := z0{dir 90}..z2..z3{down}..z4{left}..z5{up}..z6{right}..{up}z7;

pen_stroke(
  nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5,6,7)

)(paths[p])(strokes[p]);
endglyph;
