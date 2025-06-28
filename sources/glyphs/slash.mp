input glyph;

beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
z0= (X/2, 0.95X);
z1=( X/4, 0);

paths[0] = z0{dir 260}...z1 ;

pen_stroke(
    nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

endglyph;
