input glyph;
beginglyph;

% The stroke of N
z0 = (0, 0.0);
z1 = (x0, 0.95X);
z2 = (0.6Xw, y0);
z3 = (x2, y1);

paths[p] =  z0{dir 80} ..{dir 100} z1{dir -60}..{dir -50}z2{dir 100}..{dir 80}z3 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

% Hook, from the foot of the right stem
clearxy;
p:=p+1;
z0=point 2 of paths[0];
z1=(x0-X/3, -descent*0.8);
paths[p]=z0{down}..{dir 160}z1;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

endglyph;
