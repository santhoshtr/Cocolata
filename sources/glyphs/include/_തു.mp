clearxy;

z0 =  point infinity of paths[p-1];
z1= (x0, (y0 + y2)/2);
z2 = ( x1+ mw/2.5, 0.85m); % top
z3 = ( x1 + 0.8mw, (y2+y4)/1.6);
z4 = ( (x3+x5)/2 , undershoot); % bottom middle
z5 = ( x2, m/2);
z6 =(x5 + mw/2, 0.8m);
z7 =(x6 + mw/2.5, (y6+y8)/2);
z8 = (x4, -m/3);
z9 = (x7+ thick/2, y8   );

paths[p]:=z0{up}..{dir 20}z2..z3..z4..z5..{dir 10}z6..z7{down} ..{left}z8--z9;
paths[p] :=harmonize(paths[p]);

pen_stroke(
    nib(thicknib  )(0,1,2,3,4,5,6,7,8, 9)
)(paths[p])(strokes[p]);
