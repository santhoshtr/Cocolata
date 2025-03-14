input glyph;
beginglyph;

z0=(0, s-overshoot);
z1=(x0 + 0.15sw, undershoot);
z2=(x1  + 0.33sw, 0.9s);
paths[p] := z0{dir -60}..{down}z1{up}..{dir 30}z2;
paths[p] :=  harmonize(paths[p] );
pen_stroke(
    nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);

rbearing:=0;

endglyph;
