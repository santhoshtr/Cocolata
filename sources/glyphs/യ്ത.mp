input glyph;

beginglyph;
input ./glyphs/include/യ;

p:=p+1;
clearxy;
input ./glyphs/include/ത;

paths[p]:=paths[p] shifted (0.3mw, -1.0m) scaled 0.8 ;
pen_stroke(
    nib(thicknib scaled 0.8)(0, 1, 2, 3, 4, 5, 6, 7, 8)
)(paths[p])(strokes[p]);

anchor( "vc", (x1,0));
anchor( "right", point 8.25 of paths[0]);

endglyph;
