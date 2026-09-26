input glyph;
beginglyph;

clearxy;
z0 = (0,undershoot);
z1=((x0+x2)/2, 0.8m); % Top of arch
x2-x0 = 0.6mw;
z2=(x2, y0);

paths[p] =  z0{dir 80}...z1...{dir -80}z2;
paths[p]:=harmonize(paths[p]);
pen_stroke(
 nib(thicknib)(0,1,2,3)
)(paths[p])(strokes[p]);

p:=p+1;
clearxy;
z0 = point infinity of paths[p-1];
z1 = ( x0 + mw/4, 0.9m); % top
z2 = ( x0 + 0.8mw, (y1+y3)/1.6);
z3 = ( x2 - mw/6 , undershoot); % bottom middle
z4 = ( x3 - mw/4, m/2);
z5 = (x2, X);

paths[p]:=z0{dir 80}...z1{right}..z2 ..z3..z4..z5  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib )(3)
    nib(thicknib)(4)
    nib(thicknib)(5)
)(paths[p])(strokes[p]);


endglyph;
