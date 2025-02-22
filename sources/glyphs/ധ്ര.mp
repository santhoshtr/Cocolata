input glyph;
beginglyph;

input ./glyphs/include/left_arch_dha;
paths[p] := paths[p] shifted (mw/3,0);
strokes[p]:=strokes[p] shifted (mw/3,0);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;
xshift:= xpart right_extrema(strokes[p-1]) - vertical_thin_nib_size + thick/2;
paths[p]:=paths[p] shifted (xshift, 0);
strokes[p]:=strokes[p] shifted (xshift, 0);

clearxy;
p:=p+1;
z0=point 3.25 of paths[p-1];
z1=(xpart(point 1.5 of paths[p-1]), reph_sign_depth);
z2=(xpart(point 2.5 of paths[0]), y1);
z4=(xpart point 1 of paths[0] - mw/6, m);
paths[p] := z0{dir angle(direction 3.25 of paths[p-1])*-1}...{left}z1..z2{left}.. {dir 60}z4;
dt := directiontime dir 90 of subpath(2, 3) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt);
paths[p]:=harmonize(paths[p]);

pen_stroke(
    nib(middle_up_nib)(0)
    nib(downnib)(1,2)
    nib(endnib)(3)
    nib(end_nib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart(point 3 of paths[0]),0));
anchor( "right", point 0.75 of paths[p]);
endglyph;
