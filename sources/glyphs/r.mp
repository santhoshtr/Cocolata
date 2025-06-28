input glyph;
beginglyph;

z0=(0, s-overshoot);
z1=(x0 + 0.15sw, undershoot);
z2=(x1  + 0.33sw, 0.9s);
z3=(x2  + 0.1sw, 0.8s);
paths[p] := z0{dir -60}..{down}z1{up}..{dir 30}z2..{dir -90}z3;
paths[p] :=  harmonize(paths[p] );
pen_stroke(
    nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

endglyph;
