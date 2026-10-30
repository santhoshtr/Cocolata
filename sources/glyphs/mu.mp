input glyph;
beginglyph;

% The stroke of u
z0 = (0, 0.9s);
z1 = (0.35(x0 + x2), undershoot);
z2 = (0.6sw, y0);
z3 = (x2  + 0.1sw, 0);

paths[p] =  z0{dir -100} ..z1...{dir 80}z2{dir -100}.. z3 ;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3)
)(paths[p])(strokes[p]);

% Descender, from the left side of u
clearxy;
p:=p+1;
z0=point 0.3 of paths[0];
z1=(x0, -descent);
paths[p] := z0{down}..z1;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

endglyph;
