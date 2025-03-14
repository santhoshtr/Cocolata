input glyph;
beginglyph;

z0=(0, undershoot);
z1=(x0+sw/3  ,s-overshoot);
paths[p] := z0{dir 45}..{up}z1;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0=(0.75sw, s-overshoot);
z1=(x0+sw/4 , 2undershoot);
z2=(x1+sw/4 ,s/4);
paths[p] := z0{down}...z1 ...{dir 60}z2;
pen_stroke(
   nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

strokes[p]:=harmonize(strokes[p]);


p:=p+1;
clearxy;
z0=(0, 0.8s);
z1=(x0+sw/4, s-overshoot);
z2=(x1+0.75sw, y1);
paths[p] := z0..z1---z2;
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4 )
)(paths[p])(strokes[p]);

endglyph;
