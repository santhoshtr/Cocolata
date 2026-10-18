input glyph;
beginglyph;
z0 = (x1+0.2Xw, y1-0.1X);
z1 = (Xw/2, X - overshoot);
z2 = (0, 0.75s);
z3 = ((x2+x4)/2, undershoot);
z4 = (x0, 0.4X  );
paths[p]:=z0...z1{dir 190}...z2{dir 253}...z3 ...z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0 = point infinity of paths[p-1] + (-0.15Xw, 0);
z1 =  point infinity of paths[p-1];
z2 = (x1+0.1sw, 0);
paths[p]:=z0...{right}z1{dir -90}...z2;
pen_stroke(
     nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
anchor( "bottom", (xpart(point 3 of paths[0]), 0));
endglyph;
