input glyph;
beginglyph;
input ./glyphs/include/ഢ;

for i=0 upto p:
    paths[i] := paths[i] shifted (mw/3, 0);
    strokes[i] := strokes[i] shifted (mw/3, 0);
endfor;

clearxy;
p:=p+1;
z0=point 2 of paths[p-1];
z1=(xpart(point 0 of paths[p-1]), reph_sign_depth);
z2=(xpart(point 3.5 of paths[0]), y1);
z4=(xpart point 1 of paths[0] - mw/4, 0.9m);
paths[p] := z0{dir -100}...z1---z2.. z4;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);

pen_stroke(
  nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart( point infinity of paths[0]),0));
anchor( "right", point .75 of paths[p]);
endglyph;
