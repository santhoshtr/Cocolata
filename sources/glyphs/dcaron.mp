input glyph;
beginglyph;

% The strokes of d
z0 = (x1+0.2sw, y1-0.1s);
z1 = (sw/2, 0.9s);
z2 = (0, 0.5s);
z3 = ((x2+x4)/2, undershoot);
z4 = (x0, 0.5s );

paths[p]:=z0...z1{dir 190}...z2{dir 250}...z3 ...{up}z4;
paths[p] := harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0, 1, 2, 3, 4)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(xpart point 4 of strokes[p-1], X);
z1=(x0 , 0);
paths[p] := z0{dir -100}...{dir -80}z1;
pen_stroke(
   nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Caron: a wedge at the right of the stem top
clearxy;
p:=p+1;
z0 = point 0 of paths[1] + (sw/4, 0);
z1 = (x0, y0-s/3);
paths[p] = z0{dir -75}..z1;
pen_stroke(
    nib(thicknib)(0)
    nib(thinnib)(infinity)
)(paths[p])(strokes[p]);

rbearing:=rbearing/2;
endglyph;
