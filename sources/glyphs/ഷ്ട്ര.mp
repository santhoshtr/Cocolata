input glyph;
beginglyph;

input ./glyphs/include/ഷ.mp;

clearxy;
p:=p+1;
z0= (x1 + mw/2, 0.95m);
z1 = (mw/3, 3/4m);
z2 = ((x0+x1)/2, m/2);
z3 = (x0 + 0.1mw, m/3);
z4 = ( x1 , 0.1m);
z5 = (0 , 0.5m);
z6 = (x5 + mw/6 , y0);

paths[p]:=z0{dir 170}..{dir 235}z1..z2..z3..{dir 170}z4..z5..z6 ;
paths[p]:=harmonize(paths[p]);
paths[p] := paths[p] shifted (0.65mw, -1.1m) xscaled 0.75 yscaled 0.75;
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib rotated 30)(2)
    nib(thicknib)(3)
    nib(thicknib)(4,5,6)
)(paths[p])(strokes[p]);

anchor( "vc", point 0.5 of paths[1]);

endglyph;
