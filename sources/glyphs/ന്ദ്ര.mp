input glyph;
beginglyph;
input ./glyphs/include/left_arch;
paths[p]:=paths[p] shifted (mw/3, 0) ;
strokes[p]:=strokes[p] shifted (mw/3, 0) ;

p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0, (y0 + y2)/2);
z2 = ( x1 + mw/2, 0.9m); % top
z3 = ( x2 + mw/3, y2 - m/6);
z4 = ( x3 - mw/3, (y3+ y5)/2); % <
z5 = ( x3+ thick/4, 0.15m);
z6 = ( x0, -descent/2 );
z7 = ( 0, (y6 + y8)/2 );
z8 = ( x7 + mw/6, 0.9m );

paths[p] =z0{up}..{dir 10}z2..z3..{left}z4{dir 10}..z5 ..  {left}z6..z7..z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib  )(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);

anchor( "vc", point 0 of paths[p]);
anchor( "right", point 6.5 of strokes[p]);

endglyph;
