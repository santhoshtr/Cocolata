input glyph;
beginglyph;
input ./glyphs/include/ത_;

p:=p+1;
input ./glyphs/include/_ത;

% ൃ sign: continue the right side of the bowl into the loop, as in തൃ
clearxy;
z0 = point 6 of paths[p];
z1 = (x0 - mw/2, -descent*0.8);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/6);
z4 = (x1 + mw/4, y2);
paths[p] := (subpath(0,6) of paths[p]) & z0{down}..z1{left}..z2{up}..z3..z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1)
    nib(thicknib rotated -30)(2)
    nib(thicknib)(3, 4, 5, 6, 7, 8, 9, 10)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point infinity of paths[0]),0));
endglyph;
