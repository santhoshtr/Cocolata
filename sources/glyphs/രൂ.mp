input glyph;
beginglyph;
clearxy;
z0= (x1 + thick/2, undershoot);
z1= (mw/3, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/2);
z4 = ( x2+ mw/4 , 0); % bottom middle
z5 = ( (x1+x3)/2.2, 0.5m);
z6 = ( x5 + mw/3, 0.9m);
z7 = ( x6 + mw/2, 0.8m);
z8 = ( x6 + mw/3, 0.45m); % <
z9 = ( x8 + mw/3, 0.2m);
z10 = ( x4, -descent/2);
z11 = (0, (y10+y12)/2);
z12 = (x11+thick/2, 0.95m);

paths[p]:=z0..z1..z2{dir -10}..z3..z4..z5..z6..
    z7..{left}z8{dir -10}..z9..{left}z10..z11..z12;
paths[p] :=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4,5,6,7,8,9,10,11,12)
)(paths[p])(strokes[p]);
endglyph;


