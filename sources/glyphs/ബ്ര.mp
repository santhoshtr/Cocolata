input glyph;
beginglyph;

input ./glyphs/include/ബ;

for i=0 upto 1:
    paths[i] := paths[i] shifted (mw/3, 0);
    strokes[i] := strokes[i] shifted (mw/3, 0);
endfor;
p:=p+1;
clearxy;
z0 = (xpart point 4 of paths[p-1], 0);
z1 = (xpart point 3 of paths[p-1], reph_sign_depth  );
z2 = (xpart point 3 of paths[p-2], y1);
z3 = (xpart(point 4 of paths[0]) - mw/4 , 0.9m);
paths[p] =  z0{down}..z1--- z2..{dir 80}z3;
dt := directiontime dir 100 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2+ dt);
pen_stroke(
  nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 5 of paths[0]),0));
anchor( "right", point 0.75 of paths[p] );
endglyph;
