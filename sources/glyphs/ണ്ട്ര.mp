input glyph;
beginglyph;
input ./glyphs/include/ണ;

for i=0 upto 2:
    paths[i] := paths[i] shifted (mw/3, 0);
    strokes[i] := strokes[i] shifted (mw/3, 0);
endfor;

% Third arch

p:=2;
clearxy;
z0 = point infinity of paths[1];
z1 = ( x0 + mw/2.2, m - overshoot); % top
z2 = ( x1 + mw/3, y3 + m/8);
z3= ( x2 - mw/5, y4 + m/6);
z4= ( x3 - mw/5, m/2);
z5= ( x4 + mw/5, y6 + m/6);
z6 = ( x5 + mw/4, m/6);
z7 = ( xpart point 1 of paths[1], -m/2);
z8 = ( xpart point 4 of paths[0] - mw/3, m/3);
z9 = (x8 +  mw/6, 0.9m);
paths[p] := z0{up}..z1{dir 10}..z2 ..z3 ..z4..z5 ..z6{dir 280}
 ..{dir 180}z7..z8{up}..z9;

pen_stroke(
      nib(thicknib)(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);

anchor( "vc", point 1 of paths[1]);
anchor( "right", point 6.5 of paths[p]);

endglyph;
