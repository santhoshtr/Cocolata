input glyph;
beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
z0= (0, 0.95X);
z1=( x0 + sw/2, 0);

paths[0] = z0--z1 ;

pen_stroke(
    nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

endglyph;
