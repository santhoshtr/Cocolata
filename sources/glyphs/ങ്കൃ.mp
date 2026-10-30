input glyph;
beginglyph;
clearxy;
z0=(mw/2, 0.65m);
z1=((x0 + x2)/2.25, m-overshoot);
z2=(x0 + 0.6mw, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(x0, m/3);
z5=(x4-mw/4, y3);
z6=(x5-mw/4, 0.3m);
z7=(x2, y2);
z8=(x7+mw/4, y6);
z9=(x2 , -descent*0.8);
z10 = (x9 - mw/3, (y9+y11)/2);
z11= (x9, y10+m/6);
z12= (x9 + mw/4, y10);

paths[p] := z0 ..{right}z1..{down}z2..z3{left}..{up}z4{down}..z5{left}..{dir 60}z6.. z7..{dir 180}z9..z10{up}..z11..z12;
paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11,12)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=point 6.5 of paths[p-1];
z1=(0, (y0+y2)/2);
z2=((x1+x3)/2, m-overshoot);
z3=point 0 of paths[p-1];
paths[p] := z0{left}..z1{up}..z2{right}..{down}z3;
paths[p] := harmonize(paths[p]);
pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

anchor( "vc", z2);

endglyph;
