input ./glyphs/include/ക;

clearxy;
z0=point infinity of paths[p-1];
z1=(x0 - mw/4, undershoot);
z2=(x1 - mw/4, y1 + 0.25m);
z3=(x2 + mw/3, y2 + 0.3m);
z4=(xpart point 2 of paths[p-1] + mw/2.5, y3);
z5=(x4 + mw/3, (y4+ y6)/2);
z6=(x5 - mw/4, y1);
z7=(x6 - mw/4, (y6 + y8)/2);
z8=((x7+x9)/2, m-overshoot);
z9=(x7 + 0.95mw, (y8+y10)/2);
z10=(x9 - mw/4, 0);

paths[p] := z0{down}..z1{left}..z2{up}..z3---z4..z5{down}..z6{left}..z7..z8{right}..z9{down}..z10;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(middle_up_nib)(0)
   nib(down_nib)(1)
   nib(middle_down_nib scaled 0.9)(2, 5)
   nib(thin_vertical_nib rotated 90)(3, 4)
   nib(downnib)(6)
   nib(middleupnib)(7)
   nib(top_nib)(8)
   nib(middle_down_nib)(9)
   nib(end_nib rotated terminalangle 10 of paths[p])(10)
)(paths[p])(strokes[p]);
