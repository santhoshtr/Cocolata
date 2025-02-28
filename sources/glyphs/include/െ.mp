clearxy;
z0 =(thick, (y1 + y3)/1.5);
z1 =(x0 + mw/4, y3+0.55m);
z2=(x1 + mw/4, (y1 + y3)/2);
z3=(x2 - mw/4, undershoot);
z4=(0, (y1 + y3)/2);
z5=(x4 + mw/2, 0.9m);
z6=(x5 + mw/2, (y5+y7)/2);
z7=(x6 - mw/6, 0);
% Dummy path
paths[p] = z0 ..z1..z2..z3..z4{dir 100}..{curl 10} z5{right}..{down}z6..z7;
% Get the point for extrema
z8=point 4.1 of paths[p];
paths[p] := z0{dir 80}..z1..z2..z3..z8{up}..z5{right}..{down}z6..z7;
pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5)
   nib(thicknib scaled 1.2)(6, 7)
)(paths[p])(strokes[p]);
