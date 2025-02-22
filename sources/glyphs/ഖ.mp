input glyph;
beginglyph;
z0 =(0, (y1 + y3)/2);
z1 =(x0 + mw/4, y3+0.55m);
z2=(x1 + mw/4, y0);
z3=(x2 - mw/4, undershoot);
z4=(x0, y0);

paths[p]:=z0{up}..z1{right}..z2{down}..z3{left}..{up}z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(middle_up_nib)(0)
    nib(top_nib)(1)
    nib(middle_down_nib)(2)
    nib(down_nib)(3)
    nib(middle_up_nib)(4)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
start_t = 3;
z0 = point start_t of paths[p-1];
z1 = (xpart point 9 of strokes[p-1], (y0+y2)/2);
z2 = ( (x1 + x3)/1.8, m - overshoot); % top
z3 = ( x1 + mw, m/2);
z4=(x3 - mw/4+ thin*1.2/2, thin/2);
z5=(x4, 0);

paths[p]:=z0{dir angle(direction start_t of paths[p-1])}..z1{up} .. z2{right}..z3{down}..z4--z5;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(down_nib)(0)
    nib(middle_up_nib)(1)
    nib(top_nib)(2)
    nib(middle_down_nib)(3)
    nib(end_nib)(4,5)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
z0=  (0,0);
z1=(x0 + 0.6mw, y0);
z2=(x1, m);

paths[p]:= z0--z1 ;
paths[p]:= paths[p] shifted ( xpart(point infinity of paths[p-1])+thin/4, thick*thin_horizontal_nib_scale/2 );

pen_stroke(
    cut(thin_horizontal_nib, 45)(0)
    nib(thin_horizontal_nib)(1)
)(paths[p])(strokes[p]);
strokes[p]:= (xpart point infinity of strokes[p-1], ypart(point 0 of strokes[p])) -- subpath( 1, 3) of strokes[p]--cycle;

clearxy;
z0=(0, 0);
z1=(x0, m);

paths[3]:= z0--z1;
paths[3]:= paths[3] shifted (xpart(point 1 of paths[2]), 0);
pen_stroke(
    nib(thick_vertical_nib)(0)
    nib(thick_vertical_nib)(1)
)(paths[3])(strokes[3]);

anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "right", (xpart(point 1 of paths[2])-u_drop_sign_radius,u_drop_sign_vshift));

endglyph;
