input glyph;
beginglyph;
input ./glyphs/include/വ;


paths[p] := paths[p] shifted (mw/3, 0);
strokes[p] := strokes[p] shifted (mw/3, 0);



p:=p+1;
clearxy;
z0 = (xpart point 4 of paths[p-1], 0);
z1 = (3/4(x0-x2), reph_sign_depth  );
z2 = (xpart(point 0 of paths[0]) - mw/4, m);
paths[p] =  z0{down}..z1 ..{dir 60}z2;
dt := directiontime dir 90 of subpath(1, 2) of paths[p];
paths[p] := insert_nodes(paths[p])(1+ dt);
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

anchor( "vc",  point 2 of paths[0]);
anchor( "right", (point .6 of paths[1]));

endglyph;
