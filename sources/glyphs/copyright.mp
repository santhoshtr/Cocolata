input glyph;
beginglyph;

save r,e;
r=0.75;
z0 = (r*sw, y1-.3s);
z1 = ((x0 + x2)/1.8, s - overshoot);
z2 = (0, s/2);
z3 = ((x0 + x2)/1.75, undershoot);
z4 = (x0+thin*1.2/2, y3+ s/4);
paths[0]:=z0{dir 80}..z1{left}..z2{down}..z3{right}..z4;
paths[p]:=z0{dir 80}..z1{left}..z2{down} ..z3 ..z4;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4)
)(paths[0])(strokes[0]);


paths[0] := paths[0] shifted (sw/2, s/3) xscaled 0.85 yscaled 0.85;
strokes[0] := strokes[0] shifted (sw/2, s/3) xscaled 0.85 yscaled 0.85;

soften := 0;
clearxy;
z0=(0, X/2);
z1=(x0 + 0.5Xw, y0 + 0.5X - thick/4);
z2=(x1 + 0.5Xw, y0);
z3=(x1, undershoot);
z4=(x0, y2);

paths[1] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;

pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4)
)(paths[1])(strokes[1]);
endglyph;
