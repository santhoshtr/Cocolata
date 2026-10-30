input glyph;
beginglyph;
% archaic ii
r:=0.25;
z0=(0, y3+r*m);
z1=((x2+x0)/1.8, y0 +0.8r*m);
z2=(x1 + 0.8r*mw, y0);
z3=(x1, m/4);
z4=(x0, y0);

paths[0] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0)
    nib(thicknib  )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib scaled 1.3)(3)
    nib(thicknib)(4)
)(paths[0])(strokes[0]);

p:=p+1;
clearxy;
z0= (x1 + mw/8, undershoot);
z1= (xpart point 7 of strokes[0] + mw/3, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/2);
z4 = ( x2+ mw/4 , 0); % bottom middle
z5 = ( (x1+x3)/2.2, 0.4m);
z6 = ( x5 +mw/4, 0.6m);

paths[p]:=z0...z1{up}...z2{dir -10}..z3..z4..z5..z6  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4,5,6)
)(paths[p])(strokes[p]);

p:=p+1;
paths[p] = paths[0] shifted (xpart(point 12 of strokes[p-1]) + 0.1mw, 0);
pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

endglyph;
