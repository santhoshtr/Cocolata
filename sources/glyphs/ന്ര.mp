input glyph;
beginglyph;
input ./glyphs/include/left_arch;

paths[p] := paths[p] shifted (mw/3,0);
strokes[p] := strokes[p] shifted (mw/3,0);


p:=p+1;
input ./glyphs/include/right_arch;

paths[p] := subpath(0,1.75) of paths[p];

pen_stroke(
    cut(thicknib, -45)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);



p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1 = (xpart(point 0 of paths[p-1]), reph_sign_depth);
z2 = (xpart(point 2 of paths[p-2]), y1);
z3 = (xpart(point 1 of paths[p-2]) - mw/3, ypart(point 1 of paths[p-2]));
z4 = (x3 + mw/6, m-overshoot);
paths[p] =  z0{dir (angle(direction infinity of paths[p-1]))}..z1{dir -180}..z3..z4;

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1,2)
    nib(thicknib)(3)
    nib(thicknib )(4)
)(paths[p])(strokes[p]);

anchor( "right", point .8 of paths[p]);

endglyph;
