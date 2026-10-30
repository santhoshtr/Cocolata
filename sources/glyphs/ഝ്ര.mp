input glyph;
beginglyph;
input ./glyphs/include/ത_;

clearxy;
paths[p] := subpath(0, 7) of paths[p];
z8=(xpart point infinity of paths[p] + mw/4, undershoot);
z9=(x8+mw/4, 0.4m);
z10=(x9, m-thin/2);
paths[p] := paths[p]{down}..{right}z8{right}..z9---z10;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

p:=p+1;
clearxy;
z0 = point 3.25 of paths[p-1];
z1 = (xpart(point 0.8 of paths[p-1]), reph_sign_depth );
z2 = (xpart(point 2 of paths[p-2]), y1);
z3 = (xpart(point 1 of paths[p-2]) - mw/3, ypart(point 1 of paths[p-2]));
z4 = (x3 + mw/6, m-overshoot);

paths[p] =  z0{dir (angle(direction 3.25 of paths[p-1]))*-1}..{dir 200}z1...z2..z3..z4;

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1,2)
    nib(thicknib)(3)
    nib(thicknib)(4)
)(paths[p])(strokes[p]);


anchor( "vc", (xpart( point infinity of paths[0]),0));
anchor( "right", point 0.75 of paths[p]);
endglyph;
