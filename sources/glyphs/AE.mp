input glyph;
beginglyph;

% Left diagonal of A, up to the top of the E stem

z0 = (0, overshoot);
z1 = (x0 + 0.5Xw, 0.95X);

paths[p] =  z0{dir 80} ...{right}z1;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

% Stem and bottom bar of E, in one stroke as in E
clearxy;
p:=p+1;
z0=point 1 of paths[p-1];
z1=(x0, 0.1s);
z2=(x1 + 0.45Xw, y1);
paths[p] = z0{dir 260}...z1{right}..{right}z2;
pen_stroke(
   nib(thicknib)(0, 1, 2)
)(paths[p])(strokes[p]);

% Top bar of E
clearxy;
p:=p+1;
z0=point 0 of paths[p-1];
z1=(x0 + 0.45Xw, y0);
paths[p] = z0..z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Cross bar of A and middle bar of E, in one stroke
clearxy;
p:=p+1;
z0=paths[0] intersectionpoint ((-X, 0.45X)--(X, 0.45X));
z1=paths[1] intersectionpoint ((-X, 0.45X)--(X, 0.45X));
z2=(x1 + 0.4Xw, y1);
paths[p] = z0--z2;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
