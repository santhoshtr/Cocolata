input glyph;
beginglyph;
input ./glyphs/include/left_arch;

p:=p+1;
clearxy;
z0 = (xpart right_extrema(strokes[p-1]) - vertical_thin_nib_size/2, vertical_thin_nib_size/2);
z1=(x0, 0.6m);
z2=((x1+x3)/2, m - overshoot); % Top of arch
x3-x1 = mw*0.6;
z3=(x3, m-m/3);
z4=(x3, m/3);
z5= ( x4+ mw/3, undershoot);
z6= ( x5 + mw/4, m/3);
z7= ( x6, m);
paths[p] = z0---z1..z2..z3---z4..z5..z6---z7;

pen_stroke(
    cut(thin_vertical_nib, -45)(0)
    nib(thin_vertical_nib)(1)
    nib(top_nib)(2)
    nib(middle_down_nib)(3)
    nib(middle_down_nib)(4)
    nib(downnib)(5)
    nib(thin_vertical_nib)(6)
    nib(thin_vertical_nib)(7)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;
xshift:= xpart right_extrema(strokes[p-1]) - vertical_thin_nib_size + thick/2;
paths[p]:=paths[p] shifted (xshift, 0);
strokes[p]:=strokes[p] shifted (xshift, 0);

anchor( "vc", (xpart( point infinity of paths[1]),0));
anchor( "right", point 2.2 of paths[p]);

endglyph;
