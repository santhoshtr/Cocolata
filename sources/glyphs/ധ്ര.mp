input glyph;
beginglyph;

input ./glyphs/include/left_arch_dha;
paths[p] := paths[p] shifted (mw/3,0);
strokes[p]:=strokes[p] shifted (mw/3,0);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;


clearxy;
p:=p+1;
z0=point 2.25 of paths[p-1];
z1=(xpart(point 0 of paths[p-1]), reph_sign_depth);
z3=(xpart point 1 of paths[0] - mw/6, m);
paths[p] := z0{dir angle(direction 2.25 of paths[p-1])*-1}...{left}z1.. {dir 60}z3;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);
paths[p]:=harmonize(paths[p]);

pen_stroke(
  nib(thicknib)(0, 1, 2, 3,4 )
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 3 of paths[0]),0));
anchor( "right", point 0.75 of paths[p]);
endglyph;
