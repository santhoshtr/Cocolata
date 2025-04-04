input glyph;
beginglyph;

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
    nib(thicknib)(0, 1 )
)(paths[p])(strokes[p]);


anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
