input glyph;
beginglyph;


z0=(thick*1/3, 2/3s);
z1=((x0+x2)/2, s-overshoot);
z2=(x0+0.7sw, 0.6s);
z3=(x2, s/4);
z4=((x3 + x5)/2, undershoot);
z5=(x3 + 1.5thick, 0.1s);
paths[p] := z0{dir 90}.. z1{right}..z2{down}..{down}z3..z4.. z5 ;

pen_stroke(
    nib(thicknib rotated terminalangle 0 of paths[p])(0)
    nib(thicknib)(1, 2, 3, 4)
    nib(thicknib rotated terminalangle 5 of paths[p])(5)
    ignore_directions(1r, 4)
)(paths[p])(strokes[p]);




p:=p+1;
clearxy;
z0=point 2.25 of paths[p-1];
z1=(x3, y3 + 0.5s);
z2=(0, (y1 + y3)/2.2) ;
z3=((x2+x4)/2.25, 1.2undershoot);
z4=(x0, y3+0.25s);
paths[p] := z0{dir 180}..{down}z2..z3{right}..z4;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
    ignore_directions(1l, 2 ,3, 4)
)(paths[p])(strokes[p]);

for i=0 upto 1:
    paths[i] := paths[i] scaled 2/3 shifted (0, s);
    strokes[i] := strokes[i] scaled 2/3 shifted (0, s);
endfor;

lbearing:=sw/3*0.2;
rbearing:=sw/3*0.1;
anchor( "top", (xpart(point 1 of paths[0]), 0.9X));
endglyph;
