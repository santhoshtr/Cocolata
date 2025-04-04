input glyph;
beginglyph;
z0=(sw/3, 0.95X);
z1=(x0 + sw/6, thick/4);
z2=(x1 + sw/4, 0.15s);
paths[p] = z0{dir -100}...z1{right}... z2;
pen_stroke(
     nib(thicknib)(0,1,2)
)(paths[p])(strokes[p]);
%bar

clearxy;
p:=p+1;
z0 =(0, s);
z1 = (xpart point infinity of paths[p-1], s);
paths[p] = z0{dir 10}.. z1;
pen_stroke(
     nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

anchor("top", (xpart(point 0 of paths[0]), X));
anchor("bottom", (xpart(point 1 of paths[0]), 0));

rbearing:=0;
endglyph;
