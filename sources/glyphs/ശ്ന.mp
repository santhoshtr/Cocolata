input glyph;
beginglyph;
input ./glyphs/include/ശ;

p:=p+1;
input ./glyphs/include/left_arch;

p:=p+1;
input ./glyphs/include/right_arch;


paths[p-1] := paths[p-1] shifted (0.4mw, -1.1m) xscaled 0.8 yscaled 0.7;
paths[p] := paths[p] shifted (0.4mw, -1.1m) xscaled 0.8 yscaled 0.7;

pen_stroke(
      nib(thicknib)(0,1,2, 3)
)(paths[p-1])(strokes[p-1]);

pen_stroke(
     nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);

endglyph;
