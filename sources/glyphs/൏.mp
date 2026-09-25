input glyph;
beginglyph;

input ./glyphs/include/left_arch_with_eye;

for i=0 upto p:
    paths[i] := paths[i] shifted (mw/3, 0);
    strokes[i] := strokes[i] shifted (mw/3, 0);
endfor;

p:=p+1;
input ./glyphs/include/right_arch;
paths[p] := subpath(0, 2.8) of paths[p]  ;

pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
)(paths[p])(strokes[p]);


p:=p+1;
clearxy;
z0 = point 3 of paths[p-1];
z1 = (xpart point 0 of paths[p-1], reph_sign_depth);
z2 = (xpart point 5 of paths[0], y1);
z3 = (0, m/2);
z4 = (x3+mw/6, m);

paths[p] = z0{dir angle(direction infinity of paths[p-1])}.. z2 ..z3..z4;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1,2)
    nib(thicknib)(3)
    nib(thicknib rotated terminalangle 4 of paths[p])(4)
)(paths[p])(strokes[p]);


endglyph;
