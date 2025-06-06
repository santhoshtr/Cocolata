input glyph;

beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
z0= (X/2, 0.8X);
z1=( X/4, y0 - 0.5X);
z2=( 0, y1 - 0.5X);

paths[0] = z0{dir 250}...z2 ;

pen_stroke(
    nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

endglyph;
