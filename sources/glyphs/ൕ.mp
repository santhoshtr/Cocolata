input glyph;

beginglyph;

clearxy;
z0 = (mw*0.5 , 0.6m);
z1 = (x0 + mw/3, m-overshoot);
z2 = (x1 + mw/3.5, (y1+y3)/1.65);
z3 = ((x2 + x4)/2, undershoot);
x2-x4 = mw*1.2;
z4 = (x4, (y3+y5)/1.8);
z5 = ((x4 + x6)/2, y1);
z6 = (x0, y0);
z7 = (x6 + 0.05mw, (y6+y8)/2);
z8 = ((x7 + x9)/2, undershoot);
z9 = (x8 + mw/2.1, (y8+y10)/1.8);
z10 = (x9 - mw/8, m);
z11 = (x10 + mw/8, m+m/3);
paths[0] = z0{up}..z1{right}..z2 ..z3..z4 ..z5{right}..z6{down}..z7..z8{right}..z9{up}..z10..z11;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(middle_down_nib scaled 0.9)(0)
   nib(topnib)(1)
   nib(middledownnib)(2)
   nib(downnib )(3)
   nib(middleupnib)(4)
   nib(topnib)(5)
   nib(middle_down_nib scaled 0.9)(6)
   nib(middle_down_nib)(7)
   nib(downnib)(8)
   nib(middleupnib )(9)
   nib(endnib)(10)
   nib(end_nib rotated terminalangle 11 of paths[0])(11)
)(paths[0])(strokes[0]);


rbearing:=0;

endglyph;
