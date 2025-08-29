input glyph;
beginglyph;

input ./glyphs/include/ഷ;
paths[p-1] := paths[p-1] shifted (mw/3, 0);
strokes[p-1] := strokes[p-1] shifted (mw/3, 0);


paths[p] := paths[p] shifted (mw/3, 0);
strokes[p] := strokes[p] shifted (mw/3, 0);

p:=p+1;
clearxy;
z0 = (xpart point 4 of paths[p-1], 0);
z1 = (3/4(x0-x3), reph_sign_depth  );
z2 = (0.5(x0-x3), y1);
z3 = (xpart(point 1 of paths[0]) - mw/4, m);
paths[p] =  z0{down}..z1{left}..{dir 60}z3;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2+ dt);
pen_stroke(
   nib(thicknib)(0,1,2, 3,4)
)(paths[p])(strokes[p]);
anchor( "vc", point 0.5 of paths[0]);
anchor( "right",  point 0.6 of paths[p]);

endglyph;
