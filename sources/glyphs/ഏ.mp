input glyph;
beginglyph;

input ./glyphs/include/എ;
clearxy;

z0= point 1 of paths[p-1];
z1= (x0-mw/4, y0-0.4m);
z2 = (x1-mw/4, 0.4m);
z3 = (x0, 0.95m);
z4 = (x3+mw/4, 0.5m);
z5 = (x4, 0);
paths[p]:=z0{down}..z1..z2..z3..{dir 215}z4{dir -10}..z5;
pen_stroke(
    nib(thicknib)(0,1,2,3,4,5)
)(paths[p])(strokes[p]);
endglyph;
