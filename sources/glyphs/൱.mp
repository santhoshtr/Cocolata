input glyph;
beginglyph;
input ./glyphs/include/left_arch;

p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1=(x0, 0.6m);
z2=((x1+x3)/2.1, 0.9m); % Top of arch
x3-x1 = 0.75*mw;
z3=(x3, (y2+y4)/2);
z4= (x3 - mw/2, -descent*0.8);
paths[p]= z0{dir 90}..z2..z3{down}..z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

endglyph;
