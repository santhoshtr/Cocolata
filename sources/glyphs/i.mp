input glyph;
beginglyph;


z0=(0, s);
z1=(x0 ,  0);
paths[p] := z0{dir -100}.. z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


p:=p+1;
paths[p] = fullcircle scaled (thick*1.5) shifted(x1, 1.33s);

strokes[p] = paths[p];


endglyph;
