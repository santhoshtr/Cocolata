clearxy;
z0 =  point infinity of paths[p-1];
z1= (x0, (y0 + y2)/2);
z2 = ( x1+ mw/2.5, 0.85m); % top
z3 = ( x1 +  0.9mw, (y2+y4)/1.6);
z4 = ( x3 - mw/4 , 0); % bottom middle
z5 = (  x4 - mw/4, 0.5m);
z6 = ( x5 + mw/3, 0.85m);
z7 = ( x6 + mw/2, 0.75m);
z8 = ( x6 + mw/3, 0.45m);
z9 = ( x8 + mw/3, 0.25m);
z10 = ( x4, -descent/2);
z11 = ( x9, y10);

paths[p]:=z0{up}..z2{dir 10}..z3..z4..z5..z6..z7
    ..{dir 200}z8{dir -10}..z9..{dir 200}z10{dir 10}..z11;
paths[p] :=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4,5,6,7,8,9,10,11)
)(paths[p])(strokes[p]);
