input glyph;
beginglyph;
z0=(0.5Xw, X-thin/2);
z1=(0, 0.5X);
z2=(x0, thin/2);

paths[p] = z0{left}..{down}z1..{right}z2;

pen_stroke(
   nib(thicknib)(0, 1, 2)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0= (xpart point 0 of paths[p-1], X);
z1=( x0, (y0+y2)/2);
z2=( x1, 0);

paths[p] = z0--z2 ;
pen_stroke(
   nib(thicknib)(0, 1, 2)
)(paths[p])(strokes[p]);

% Top bar
p:=p+1;
clearxy;
z0 = point 0 of paths[0];
z1 = (x0 + Xw*0.6, y0);

paths[p] = z0--z1 ;

pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Middle bar
p:=p+1;
clearxy;
z0 = point 0.5 of paths[1];
z1 = (x0 + sw*0.6, y0);
paths[p] = z0--z1;
pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

% Bottom bar
p:=p+1;
clearxy;
z0 = point infinity of paths[0];
z1 = (x0 + sw*0.9, y0);

paths[p] = z0--z1 ;

pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);

endglyph;
