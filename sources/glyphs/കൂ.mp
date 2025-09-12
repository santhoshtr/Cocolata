input glyph;
beginglyph;

% input ./glyphs/include/കൂ;
z0=(mw/2, 0.65m);
z1=((x0 + x2)/2.25, m-overshoot);
z2=(x0 + 0.6mw, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(x0, m/3);
z5=(x4-mw/4, y3);
z6=(x5-mw/4, 0.3m);
z7=(x2 , 0.7m);
z8=(x9 + mw/4, (y7+y9)/2);
z9=(x2 +  mw/4,  (y8+y10)/2); % <
z10=(x9 + mw/4.5, 0.1m);
z11=(x7 -mw/4 , -2descent/3);
z12=(x10 , y11);
paths[p] := z0 ..{right}z1..{down}z2..z3{left}
    ..{up}z4{down} ..z5{left}..{dir 45}z6
    .. z7..z8
   ..{dir 190}z9{dir -10}..z10
   ..{dir 195}z11--z12;

paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11,12)
)(paths[p])(strokes[p]);

anchor( "vc", point 1 of paths[0]);

endglyph;
