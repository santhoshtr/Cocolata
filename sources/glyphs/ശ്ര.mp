input glyph;
beginglyph;
input ./glyphs/include/ശ;

clearxy;
p:=p+1;
z0 = point infinity of paths[p-1];
z1 = (xpart point 7 of paths[p-1], reph_sign_depth);
z2 = (xpart point 3 of paths[p-1], y1);
z3 = (xpart point 1 of paths[p-1] -mw/3 +mw/6, ypart point 0 of paths[p-1]);
paths[p] =  z0{right}..z1---z2..{dir 60}z3;
dt := directiontime dir 270 of paths[p];
paths[p] := insert_nodes(paths[p])(dt);
dt := directiontime dir 90 of subpath(3, 4) of paths[p];
paths[p] := insert_nodes(paths[p])(3+ dt);
pen_stroke(
   nib(top_nib)(0)
   nib(middle_down_nib)(1)
   nib(thick_horizontal_nib)(2,3)
   nib(end_nib)(4)
   nib(end_nib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

anchor( "right",   point 1.5 of paths[p]);
endglyph;
