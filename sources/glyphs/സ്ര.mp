input glyph;
beginglyph;

input ./glyphs/include/സ;

for i=0 upto p:
    paths[i] := paths[i] shifted (mw/3, 0);
    strokes[i] := strokes[i] shifted (mw/3, 0);
endfor;


clearxy;
p:=p+1;
z0=point 3.65 of paths[p-1];
z1=(xpart(point 1 of paths[p-1]), reph_sign_depth);
z2=(xpart(point 3 of paths[0]), y1);
z4=(xpart point 1 of paths[0] - mw/6, m);
paths[p] := z0{dir angle(direction 3.65 of paths[p-1])*-1}...z1---z2.. {dir 60}z4;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);
pen_stroke(
  nib(thicknib)(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);

anchor( "vc", point 3 of paths[0]);
anchor( "right", point .75 of paths[2]);

endglyph;
