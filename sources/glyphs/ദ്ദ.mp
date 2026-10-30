input glyph;
beginglyph;
input ./glyphs/include/ദ;


clearxy;
p:=p+1;
z0 = point 5.7 of paths[0];
z1 = (x0 + mw/3.5, (y0 + y2)/2);
z2 = (x0, -descent);
z3 = (x2 - mw/4, y2 + mw/10);

paths[p] = z0{right}..z1..z2..z3 ;

pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

anchor( "vc", point 2 of paths[0]);
anchor( "right", point 1.5 of paths[p]);

endglyph;
