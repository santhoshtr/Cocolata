input glyph;
beginglyph;
input ./glyphs/include/left_arch;

p:=p+1;
clearxy;
z0=  point infinity of paths[p-1];
z1=(x0, m*0.6);
z2=(x1+mw/3, m - overshoot); % Top of arch
z3=(x2+mw/2, 0.4m);
z4= (x3 - mw/4, 0.1m);
z5= (x4 - mw/4, (y4 + y6)/3);
z6= (x4, ascent);


paths[p] := z0{up}..z2..z3..z4..z5{up}..{up}z6;

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib)(6)
)(paths[p])(strokes[p]);

endglyph;
