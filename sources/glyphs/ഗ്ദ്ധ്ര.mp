input glyph;
beginglyph;
input ./glyphs/include/ഗ;

paths[p] := subpath (0, 4) of paths[p];
clearxy;
z6 = (xpart point infinity of paths[p] + mw/3, (m-overshoot+y7)/2);
z7 = (x6 - mw/4, m/1.75);

paths[p] := paths[p].. z6{down}..{left}z7 ;
paths[p] := subpath(0, 6) of paths[p];
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

% Connector
clearxy;
p:=p+1;
z0= point infinity of paths[p-1];
z1=(x0 + mw/3, (y0 + y2)/2);
z2=(x1 - mw/4, (y1 + y3)/2);
z3=(x2 + mw/4, overshoot);
z4=(x3 + mw/2.5, 0.8m);
paths[p] = z0{dir -10}.. z1.. z2 ..{right}z3..{up}z4;

paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

p:=p+1;
clearxy;
z0=point 2.3 of paths[p-1];
z1=(xpart(point 1 of paths[p-1]), reph_sign_depth);
z2=(xpart(point 2 of paths[0]), y1);
z4=(xpart point 1 of paths[0] - mw/6, m);
paths[p] := z0{dir angle(direction 2.3 of paths[p-1])*-1}...z1{dir 200}..{dir 160}z2.. {dir 60}z4;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);

pen_stroke(
      nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);

anchor( "vc", point 5 of paths[0]);
anchor( "right", point 0.75 of paths[p]);
endglyph;
