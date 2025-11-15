input glyph;
beginglyph;

input ./glyphs/include/പ;


p:=p+1;
clearxy;
input ./glyphs/include/ത;

paths[p]:=paths[p] shifted (0.2mw, -1.04m) xscaled 0.8 yscaled 0.7;
pen_stroke(
    nib(thicknib rotated terminalangle 0 of paths[p])(0)
    nib(thicknib)(2,6)
    nib(thicknib)(3,7)
    nib(thicknib)(4)
    nib(thicknib)(1,5)
    nib(thicknib)(8)
)(paths[p])(strokes[p]);

anchor( "vc", (x3,0));

endglyph;
