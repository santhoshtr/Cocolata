input glyph;
beginglyph;

% The strokes of Y
z0 = (0.5Xw, X);
z1 = (x0-0.3Xw, undershoot);
paths[p] =  z0{dir -100}...{dir -100}z1;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0 = (0, X);
z1 = point 0.6 of paths[p-1] ;
paths[p] =  z0{dir -80} ...z1;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Two bars, centred on the stem
for bar_y = 0.6s, s/3:
    clearxy;
    p:=p+1;
    z0 = paths[0] intersectionpoint ((-X, bar_y)--(X, bar_y));
    paths[p] = (x0 - 0.35sw, y0)--(x0 + 0.35sw, y0);
    pen_stroke(
        nib(thicknib)(0, 1)
    )(paths[p])(strokes[p]);
endfor;

endglyph;
