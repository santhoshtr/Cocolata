input glyph;
beginglyph;

z0=(0, X);
z1=(x0 , 0);
paths[p] := z0{dir -80}...{dir -100}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

% /
clearxy;
p:=p+1;
z0= (xpart(point 0.5 of paths[0]), X/3);
z1= ( x0 + 0.6Xw, X);

paths[p] = z0{dir 60}..z1;
pen_stroke(
  nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

% \
p:=p+1;
clearxy;
z0 = point .2 of paths[p-1];
z1 = (xpart point 1 of paths[p-1] + thick/2, 0);
paths[p] = z0{dir -60}...z1;


pen_stroke(
 nib(thicknib)(0,1)
)(paths[p])(strokes[p]);


endglyph;
