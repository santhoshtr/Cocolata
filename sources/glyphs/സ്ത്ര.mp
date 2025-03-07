input glyph;
beginglyph;
input ./glyphs/include/സ;

p:=p+1;
clearxy;

z0= (x1 + thick/2, undershoot);
z1= (mw/3, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/4 , 0); % bottom middle
z5 = ( (x1+x3)/2.2, m/2);
z6 =(x5 + mw/2, 0.85m);
z7 =(x6 + mw/2.5, 0.5m);
z8 = ( x4, -descent/2);
z9 = (0, (y10+y8)/2);
z10 = (x9+thick/2, 0.95m);

paths[p]:=z0..z1..z2 ..z3..z4..z5..z6..
    z7..z8{left}..z9..z10;
paths[p] :=harmonize(paths[p]);
pen_stroke(
     nib(thicknib)(0,1,2,3,4,5,6,7,8,9,10)
)(paths[p])(strokes[p]);

paths[p]:=paths[p] shifted (0.75mw, -0.85m) scaled 0.75 ;
strokes[p]:=strokes[p] shifted (0.75mw, -0.85m) scaled 0.75 ;

anchor( "vc", (x3,0));

endglyph;
