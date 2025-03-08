input glyph;
beginglyph;
input ./glyphs/include/left_arch_with_eye;

p:=p+1;
input ./glyphs/include/_ത_;

clearxy;
p:=p+1;
z0=point infinity of paths[p-1] ;
z1=(x0 + mw/3, 0.9m);
z2=(x1 + mw/3, 0.45m);
z3=(x0 - mw/4, -descent/3);
z4=(x2 , 0);
z5 = (x4, y3);
z6 = (x4 - mw/3, y4);
z7 = (x4 + mw/3, y6);
z8 = (x7 - mw/4, y7-mw/6); % <
z9 = (x8 + mw/3, y8-mw/6);
z10 = (x3 + mw/2, -descent);
z11 = (x9+mw/4, y10);

paths[p] = z0{up}..{dir 20}z1..z2..{dir 220}z3{dir 30}..z4
    ..z5..z6{dir 60} ..{down}z7..{left}z8{right}..z9..{left}z10{right}..z11;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2, 3,4,5,6,7,8,9,10,11)
)(paths[p])(strokes[p]);
rbearing:=-mw/4;

endglyph;