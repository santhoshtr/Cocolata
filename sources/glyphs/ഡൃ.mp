input glyph;
beginglyph;
input ./glyphs/include/ഡ;

p:=p+1;
clearxy;
% ഋ sign
z0 = point 2.25 of paths[p-1];
z1 = (x0 - mw/2, -descent*0.8);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/6);
z4 = (x1 + mw/3, y2);
paths[p] = z0{dir angle(direction 2.25 of paths[p-1])*-1}.. {left}z1..z2{up}..z3..z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);

anchor( "vc", (xpart( point infinity of paths[0]),0));
endglyph;
