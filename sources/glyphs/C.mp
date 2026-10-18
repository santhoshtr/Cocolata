input glyph;
beginglyph;

z0 = (x1+0.2Xw, y1-0.1X);
z1 = (Xw/2, X - overshoot);
z2 = (0, 0.75s);
z3 = ((x2+x4)/2, undershoot);
z4 = (x0, 0.2X  );

paths[p]:=z0...z1{dir 190}...z2{dir 250}...z3 ...z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
anchor( "bottom", (xpart(point 3 of paths[0]), 0));
endglyph;
