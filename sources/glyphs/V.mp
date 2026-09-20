input glyph;
beginglyph;
z0 = (0, 0.9X);
z1 = (0.5(x0 + x2), undershoot);
z2 = (0.6Xw, y0);


paths[p] =  z0{dir -66}..z1--z2 ;

pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[0]), 1.1X));
endglyph;
