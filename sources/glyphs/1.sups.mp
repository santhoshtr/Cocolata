input glyph;
beginglyph;

% The stroke of 1, at the superscript position
z0=(mw/10, X);
z1=(x0, 0.55s);
paths[p] = z0{dir 280}..z1;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

lbearing:=2*lbearing;
rbearing:=2*rbearing;
endglyph;
