input glyph;
beginglyph;
clearxy;


z0= (0, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/4 , 0); % bottom middle
z5 = ( (x1+x3)/2.2, m/2);
z6 =(x5 + mw/2, 0.85m);
z7 =(x6 + 0.75mw, 0.5m);
z8 =((x7 + x9)/2, undershoot);
z9 =(x3 + mw/4, 0.5m);
z10 =(x7, X);

paths[p]:=z0..z1..z2{right}..z3..z4..z5..z6..z7..z8..z9...z10  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib )(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib  )(3,4,5,6,7,8,9,10)
)(paths[p])(strokes[p]);

anchor( "vc", point 4 of paths[0]);
anchor( "bottom", (xpart(point 7.5 of paths[0]), 0));
endglyph;
