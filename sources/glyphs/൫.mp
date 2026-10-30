input glyph;
beginglyph;

input ./glyphs/include/ദ;
clearxy;
paths[p] := subpath(0, 4) of paths[p] shifted(mw/3,0);
z5=(xpart(point infinity of paths[0]) + 0.4mw, 0);
z6=(xpart(point 1.8 of paths[0]), reph_sign_depth);
z8=(xpart point 1 of paths[0] - mw/6, m);
z9= (point 3 of paths[0])  + (mw/3, 0) ;

paths[0] := paths[0]{right}..z5{down}..z6{left}.. {dir 50}z8..{down}z9;
dt := directiontime dir 90 of subpath( 6, 7) of paths[p];
paths[p] := insert_nodes(paths[p])(6 + dt);

pen_stroke(
    nib(thicknib)(0, 1, 2, 4, 5, 6, 7, 8, 9)
)(paths[0])(strokes[0]);

anchor( "vc", point 2 of paths[0]);
anchor( "right", (xpart point 5.25 of paths[0], ypart point 5.5 of paths[0]));

endglyph;
