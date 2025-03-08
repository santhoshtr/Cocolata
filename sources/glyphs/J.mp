input glyph;
beginglyph;
clearxy;
z0=(x3, X);
z1=(x2, X);
z2=(x3 + 0.4sw , undershoot);
z3=(0, y2 + s/4);
paths[p] = z0...{dir -10}z1{dir -80}...z2..{up}z3;

pen_stroke(
     nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);



anchor( "top", (xpart(point 0 of paths[0]), 1.1X));
endglyph;
