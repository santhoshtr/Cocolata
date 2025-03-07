input glyph;
beginglyph;

input ./glyphs/include/left_arch;
paths[p] := paths[p] shifted (mw/3,0);
strokes[p] := strokes[p] shifted (mw/3,0);

p:=p+1;
clearxy;

z0 = point infinity of paths[p-1];
z1=((x0+x2)/2, 0.75m); % Top of arch
x2-x0 = mw*0.5;
z2=(x2,(y1+y3)/1.5);
z3= ( x2 + mw/6, 0.1m);
z4= ( x3 + mw/4, 0.8m);

paths[p] = z0{up}..{dir 30}z1 ..z2{dir 270}..z3 ..{up}z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3)
     nib(thicknib rotated 30)(4)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;



clearxy;
p:=p+1;
z0=point 2.25 of paths[p-1];
z1=(xpart(point 0 of paths[p-1]), reph_sign_depth);
z2=(xpart(point 3 of paths[0]), y1);
z4=(xpart point 1 of paths[0] - mw/6, m);
paths[p] := z0{dir angle(direction 2.25 of paths[p-1])*-1}...z1{dir 190}..z2.. {dir 60}z4;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);
pen_stroke(
  nib(thicknib)(0,1,2,3,4,5,6,7,8)
)(paths[p])(strokes[p]);

anchor( "right", point 0.85 of paths[p]);
endglyph;
