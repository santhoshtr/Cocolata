input glyph;
beginglyph;


input ./glyphs/include/left_arch_dha;

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

p:=p+1;
clearxy;
% ഋ sign
z0 = point 2.25 of paths[p-1];
z1 = (x0 - 2/3mw, -descent*0.9);
z2 = (x1 - mw/3, (y1+y3)/2);
z3 = (x1, y2+m/5);
paths[p] = z0{dir angle(direction 2.25 of paths[p-1])*-1}.. {left}z1..z2{up}..z3{right};
z4 = point 2/3 of paths[p];
paths[p] := paths[p]{right}..z4;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);



anchor( "vc", (xpart(point 3 of paths[0]),0));
endglyph;
