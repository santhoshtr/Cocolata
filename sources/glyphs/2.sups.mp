input glyph;
beginglyph;
z0 = (thick/2, 1.2s);
z1 = (x0 + sw/4,X-overshoot);
z2 = (x1 + sw/3.5, 1.2s);
z3 = (thick/2, s/2 + thick*sind(45));
z4 = (x2 + thick, y3);

% The curve turns at the bottom left and continues as the base stroke, as in 2.
paths[p] := z0..z1..{dir 235}z2..{dir 235}z3{dir 5}..z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib rotated terminalangle 0 of paths[p])(0)
    nib(thicknib)(1, 2, 3)
    nib(thicknib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

endglyph;