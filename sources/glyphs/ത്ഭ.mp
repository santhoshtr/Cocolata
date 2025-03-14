input glyph;
beginglyph;
input ./glyphs/include/ത_;

p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0 + mw/2.2, m - overshoot); % top
z2 = ( x1 + mw/3, y3 + m/8);
z3= ( x2 - mw/5, y4 + m/6);
z4= ( x3 - mw/5, m/2);
z5= ( x4 + mw/5, y6 + m/6);
z6 = ( x5 + mw/4, y7 + m/8);
z7 = ( x1 - mw/8, thick*0.6);

paths[p] := z0{up}..z1{dir 10}..z2 ..z3 ..z4..z5 ..z6 ..{dir 150}z7;

pen_stroke(
      nib(thicknib)(0,1,2,3,4,5,6,7)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point infinity of paths[0]),0));
anchor( "right", point 6.5 of paths[p]);
endglyph;
