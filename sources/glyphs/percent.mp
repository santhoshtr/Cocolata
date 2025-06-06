input glyph;

beginglyph;
% This glyph does not slant. Reset slant value
slant := 0;
z0=(0, y2);
z1=((x2+x0)/2, 0.3X);
z2=(x1 + Xw/6, (y1 + y3)/2);
z3=(x1, 0);
z4=(x0, y0);

paths[p] = z0{up}..{right}z1..{down}z2..z3{left}..{up}z4 ;
paths[p] := paths[p] shifted (0, X-0.5X);
pen_stroke(
   nib(thicknib)(0,4)
   nib(thicknib)(2)
   nib(thicknib)(1)
   nib(thicknib)(3)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0= (X/2, 0.8X);
z1=( X/4, (y0 + y2)/2);
z2=( xpart point 1 of paths[p-1],  0);

paths[p] = z0{dir 250}..z2 ;
pen_stroke(
    nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
paths[p] := paths[0] shifted (0.4X, -X + 0.5X);
pen_stroke(
   nib(thicknib)(0,1,2,3, 4)
)(paths[p])(strokes[p]);

% Connector
clearxy;
p:=p+1;
z0=point 1.25 of paths[0];
z1=point 0 of paths[1];
paths[p] = z0{dir -45}..z1;
pen_stroke(
   nib(thicknib)(0)
   nib(thicknib)(1)
)(paths[p])(strokes[p]);
endglyph;
