input glyph;
beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
z0= (0, X);
z2=( x0, 0);

paths[0] = z0--z2 ;

pen_stroke(
    nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

endglyph;
