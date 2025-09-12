input glyph;
beginglyph;

input ./glyphs/include/left_arch;

paths[p] := paths[p] shifted (mw/3,0);
strokes[p] := strokes[p] shifted (mw/3,0);

p:=p+1;
clearxy;

z0= point infinity of paths[p-1];
z1 = ( (x0 + x2)/2, 0.9m); % top
z2 = ( x0 + 0.8mw, (y1+y3)/1.6);
z3 = ( x1, 0); % bottom middle
z4 = ( x2 + mw/3, y3);
z5 = ( x4, 1.1m);

paths[p]:=z0{up} ..z1{dir 20}..z2..{left}z3{right}
..{right}z4{dir 100}..{dir 80}z5  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib  )(0)
    nib(thicknib )(1)
    nib(thicknib rotated -30)(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib scaled 1.1)(6)
)(paths[p])(strokes[p]);


p:=p+1;
clearxy;
z0 = (xpart point 4 of paths[p-1], 0);
z1 = (3/4(x0-x3), reph_sign_depth  );
z2 = (0.5(x0-x3), y1);
z3 = (xpart(point 1 of paths[0]) - mw/4, m);
paths[p] =  z0{down}..z1---z2..{dir 60}z3;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2+ dt);
pen_stroke(
   nib(thicknib  )(0)
    nib(thicknib )(1)
    nib(thicknib)(2)
    nib(thicknib  )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
    nib(thicknib )(6)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 5 of paths[0]),0));
anchor( "right", point 0.5 of paths[p]);
endglyph;
