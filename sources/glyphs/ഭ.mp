input glyph;
beginglyph;

clearxy;
z0 = (0, undershoot);
z1 = ( x0 + mw/2.2, 0.95m - overshoot); % top
z2 = ( x1 + mw/3, (y1 + y3)/2);
z3= ( x2 - mw/5, (y2 + y4)/2);
z4= ( x3 - mw/5, (y3+y5)/2); % <
z5= ( x3, (y4 +y6)/2);
z6 = ( x5 + mw/4, (y5 + y7)/2);
z7 = ( x1 - mw/8, undershoot);

paths[p] := z0..z1{dir 10}..z2 ..z3{dir 190} ...z4...{dir -10}z5 ...z6
 ...{dir 170}z7;

pen_stroke(
      nib(thicknib)(0,1,2,3,4,5,6)
      nib(thicknib rotated -30)(7)
)(paths[p])(strokes[p]);

endglyph;
