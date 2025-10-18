input glyph;
beginglyph;
z0 = (0, 0.0);
z1 = (0.5(x0 + x2), 0.95X);
z2 = (0.6Xw, y0);

paths[p] =  z0{dir 80} ...z1--z2 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0 = point 0.3 of paths[p-1] - (0.1mw,0);
z1 = point 1.65 of paths[p-1] + ( 0.1mw,0);

paths[p] =  z0..z1 ;
pen_stroke(
    nib(thicknib)(0, 1  )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
