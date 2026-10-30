input glyph;
beginglyph;

z0 = (s/2, s/2);
z1 = (x0, s);
for i=0 upto 5:
    paths[i]:=z0--z1 rotatedaround (z0, i*360/5);
    pen_stroke(
        nib(thinnib)(0)
        nib(thicknib)(1)
    )(paths[i])(strokes[i]);

endfor;

endglyph;
