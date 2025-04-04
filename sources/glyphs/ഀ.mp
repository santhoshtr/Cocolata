input glyph;
beginglyph;
% MALAYALAM SIGN COMBINING ANUSVARA ABOVE
z0=(0, m/5);
z1=((x2+x0)/2, y0 + m/5);
z2=(x1 + mw/5, y0);
z3=(x1, 0);
z4=(x0, y0);

paths[p] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
paths[p] := paths[p] shifted (0, m);
pen_stroke(
   nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);
rbearing:=0;
endglyph;
