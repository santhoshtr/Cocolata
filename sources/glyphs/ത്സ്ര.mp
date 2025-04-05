input glyph;
beginglyph;
input ./glyphs/include/ത_;

paths[p] := paths[p] shifted (mw/3,0);
strokes[p] := strokes[p] shifted (mw/3,0);

input ./glyphs/include/സ_arm;


clearxy;
p:=p+1;
z0=point 3.65 of paths[p-1];
z1=(xpart(point 1 of paths[p-1]), reph_sign_depth);
z2=(xpart(point 2.5 of paths[0]), y1);
z4=(xpart point 1 of paths[0] - mw/6, m);
paths[p] := z0{dir angle(direction 3.65 of paths[p-1])*-1}...z1---z2.. {dir 50}z4;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);

pen_stroke(
   nib(thicknib )(0)
    nib(thicknib  )(1)
    nib(thicknib )(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point infinity of paths[0]),0));
anchor( "right", point 0.85 of paths[p]);
endglyph;
