input glyph;
beginglyph;

input ./glyphs/include/left_arch_with_eye;


p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1=(x0, m*0.6);
z2=(x1 + mw/3, m - overshoot); % Top of arch
z3=(x2 + mw/2, (y2+y4)/2.5);
z4= ((x3+x5)/2, undershoot);
z5= (x3 - mw/1.9, m/3);
z6= (x5 + mw/2.5, y7 - m/4);
z7= ((x6 +x8)/2, m + m/3);
z8 = (x6 - mw/2, m + m/4);

paths[p] := z0{up}..z2..z3{down}..z4{left}..z5{up}..z6{dir 75}..{left}z7..z8;

pen_stroke(
    nib(thicknib)(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);
endglyph;
