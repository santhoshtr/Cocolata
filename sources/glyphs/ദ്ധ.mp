input glyph;
beginglyph;

z0 = ( x1 + 0.1mw , undershoot);
z1 = ( 0, (y0 + y2)/2);
z2 = ( x1 + mw/2, 0.95m); % top
z3 = ( x2 + mw/3, y2 - m/5);
z4 = ( x3 - mw/3, y3 - m/5); % <
paths[p] = z0..z1 ..{dir 10}z2..z3..{left}z4;
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

% Connector
clearxy;
p:=p+1;
z0= point infinity of paths[p-1];
z1=(x0 + mw/3, (y0 + y2)/2);
z2=(x1 - mw/4, (y1 + y3)/2);
z3=(x2 + mw/4, overshoot);
z4=(x3 + mw/2.5, 0.8m);
paths[p] = z0{dir -10}.. z1.. z2 ..{right}z3..{up}z4;
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

p:=p+1;
input ./glyphs/include/right_arch_dha;

anchor( "vc", point 2 of paths[1]);
anchor( "right", point 1 of paths[p]);

endglyph;
