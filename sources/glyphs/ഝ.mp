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
    nib(thicknib rotated terminalangle 0 of paths[p])(0)
    nib(thicknib)(2,6)
    nib(thicknib)(3, 7)
    nib(thicknib)(4)
    nib(thicknib)(1,5)
    nib(thicknib)(7)
    nib(thicknib)(8)
    nib(thicknib)(9)
    nib(thicknib)(10)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;


anchor( "vc", (xpart( point infinity of paths[0]),0));
anchor( "right", point 1.2 of paths[p]);
endglyph;
