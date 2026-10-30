input glyph;
beginglyph;

z0 = (0, y1 + m/2);
z1=(x0 + mw/3, undershoot);
z2=(x1 + mw/3, y0);
paths[p] = z0{down}..{right}z1..{up}z2;

pen_stroke(
    nib(thicknib)(0, 1, infinity)
)(paths[p])(strokes[p]);

% Vertical bar
clearxy;
p:=p+1;
z0 =(xpart(point 1 of paths[p-1]), y1 + m/2);
z1 =(x0, m/3);
paths[p] = z0--z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thinnib)(infinity)
)(paths[p])(strokes[p]);

absolute_position := 1;
endglyph;
