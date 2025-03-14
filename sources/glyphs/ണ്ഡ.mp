input glyph;
beginglyph;

input ./glyphs/include/ണ;

% the connector curve
clearxy;

z0 = point infinity of paths[p-1];
z1=((x0+x2)/2, 0.75m); % Top of arch
x2-x0 = mw*0.5;
z2=(x2,(y1+y3)/1.5);
z3= ( x2 + mw/6, 0.1m);
z4= ( x3 +mw/4, 0.8m);

paths[p] := z0{up}..{dir 30}z1 ..z2{dir 270}..z3{dir 30}..{up}z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);


clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

anchor( "vc", (xpart(point 1 of paths[2]),0));
anchor( "right", point 2.25 of paths[3]);
endglyph;
