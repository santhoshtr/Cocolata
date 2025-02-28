
z0=(x1+mw/6, 0);
z1=(0, (y0+y2)/1.8);
z2=((x1+x3)/1.8, m-overshoot);
x3-x1 = 0.6*mw;
z3=(x3, (y2+y5)*0.6);
z4=(x3, (y2+y5)*0.35);
z5=(x4+mw/4, undershoot);
z6=(x5+mw/4, 0.8m);
paths[p] := z0..z1 ..{dir 20}z2 ..  z3..{right}z5..{up}z6;
paths[p]:=harmonize(paths[p]);

pen_stroke(
    nib(thicknib)(0,1,2,3,4,5,6)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_dha;

