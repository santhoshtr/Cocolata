input glyph;
beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
z0= (X/2, X);
z1=( 0, y0 - X);

paths[0] = z0--z1 ;

pen_stroke(
    nib(thicknib rotated terminalangle 0 of paths[p])(0)
    nib(thicknib rotated terminalangle 1 of paths[0])(1)
)(paths[0])(strokes[0]);

endglyph;
