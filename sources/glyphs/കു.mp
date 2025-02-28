input glyph;
beginglyph;
clearxy;
z0=(mw/2, 0.65m);
z1=((x0 + x2)/2.25, m-overshoot);
z2=(x0 + 0.6mw, (y1 + y3)/2);
z3=(x1, undershoot);
z4=(x0, m/3);
z5=(x4-mw/4, y3);
z6=(x5-mw/4, 0.3m);
z7=(x2, 0.7m);
z8=(x2 + mw/4, 0.4m);
z9=(x8 - thick/2, 0);
paths[p] := z0 ..{right}z1..{down}z2..z3{left}..{up}z4{down}..z5{left}..{dir 45}z6.. z7..{dir 235}z8{dir 0}..{dir 170}z9;
paths[p]:=harmonize(paths[p]);

pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7)
   nib(thicknib scaled 0.8)(8)
   nib(thicknib scaled 1.2)(9)
)(paths[p])(strokes[p]);


anchor( "vc", point 1 of paths[0]);

endglyph;
