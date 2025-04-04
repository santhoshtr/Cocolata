input glyph;
beginglyph;

z0 = (x1+0.2sw, y1-0.1s);
z1 = (sw/2, 0.9s);
z2 = (0, 0.5s);
z3 = ((x2+x4)/2, undershoot);
z4 = (x0, 0.2s );

paths[p]:=z0...z1{dir 190}...z2{dir 250}...z3 ...z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.2X));
anchor( "bottom", (xpart(point 3 of paths[0]), 0));
endglyph;
