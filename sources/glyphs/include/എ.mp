
paths[p] := pa_mouth;
strokes[p] := pa_mouth_stroke(paths[p]);

p:=p+1;
clearxy;
z0=(0,0);
z1=(x0 + mw, y0);
z2=(x1, m);

paths[p]:= z0--z1 ;
paths[p]:= paths[p] shifted ( xpart(point infinity of paths[p-1])+thick/4, thick*thin_horizontal_nib_scale/2 );
paths[p]:=harmonize(paths[p]);
pen_stroke(
    cut(thin_horizontal_nib, 45)(0)
    nib(thin_horizontal_nib)(1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=(0, 0);
z1=(x0, 0.8m);

paths[p]:= z0--z1;

paths[p]:= paths[p] shifted (xpart(point 1 of paths[p-1]), 0);

pen_stroke(
    nib(thick_vertical_nib)(0)
    nib(thick_vertical_nib)(1)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=(0, 0);
z1=((x0  + x2)/2, -descent*0.8);
z2=(x0 - mw/1.8,0);
z3=(x2, m/3);
z4=(x0, m-overshoot);
z5=(x0 + mw/2, m/3);
z6=(x5 - mw/4, y1);

paths[p]:= z0{down}..z1{left}..{up}z2..z3{up}..z4{right}..z5 ..z6;
paths[p]:=harmonize(paths[p]);
paths[p]:= paths[p] shifted (xpart(point 0 of paths[p-1]), 0);
pen_stroke(
    nib(middle_down_nib rotated -10)(0,4)
    nib(down_nib)(1)
    nib(middleupnib)(2)
    nib(middle_up_nib)(3)
    nib(topnib)(4)
    nib(middle_down_nib)(5)
    nib(end_nib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);
