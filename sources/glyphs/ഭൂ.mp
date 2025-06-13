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
z7 = ( x1 , undershoot);
z8 = (x6 +thick/2, (y7+y9)/2);
z9 = (x1, -m/2);
z10 = (x0 - mw/3, y0);
z11 = (x10 + mw/4, m);
paths[p] := z0..z1{dir 10}..z2 ..z3{dir 190} ...z4...{dir -10}z5 ...z6
 ...{dir 170}z7{dir -10}..z8..{left}z9..z10..z11;

pen_stroke(
      nib(thicknib)(0,1,2,3,4,5,6,9,10,11)
      nib(thicknib)(7)
      nib(thicknib rotated -30)(8)
)(paths[p])(strokes[p]);

rbearing := 0;
endglyph;
