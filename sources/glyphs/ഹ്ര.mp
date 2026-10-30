input glyph;
beginglyph;
paths[p] := pa_mouth shifted (mw/3, 0);

z0= (0, 0.1m);
z1= (x0+mw/4, 0.4m);
z2 = (x0+mw/2, (y1+ y3)/2);
z3 = (x1 + thick, thick/4);
paths[p]:=z0{dir 90}..z1..{left}z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0 + 2/3mw , y0);
z2 = ( x1- mw/3  ,(y1+y3)/2);
z3 = ( x1  , 0.9m);
z4 = ( x1 + mw/2, y2);
z5 = ( x3, reph_sign_depth);
z6=(xpart(point 0.8 of paths[0]), y5);
z7=(xpart point 1 of paths[0] - mw/6, m);
paths[p]:=z0{right}..{right}z1{dir 160}..z2 ..z3{dir 10}..z4..{dir 200}z5..z6..z7 ;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib )(3,4,5,6,7)
)(paths[p])(strokes[p]);


anchor( "vc", point 0.5 of paths[1]);
anchor( "right", (xpart point 3.3 of paths[p], ypart point 4.7 of paths[p]));

endglyph;
