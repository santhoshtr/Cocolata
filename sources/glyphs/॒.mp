% DEVANAGARI STRESS SIGN ANUDATTA
input glyph;
beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
paths[0] = (-mw, -descent)--(0, -descent);
pen_stroke(
     nib(thicknib)(0,1)
)(paths[0])(strokes[0]);

lbearing:=0;
rbearing:=0;
endglyph;
