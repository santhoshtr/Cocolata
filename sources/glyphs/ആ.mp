input glyph;
beginglyph;
clearxy;
z0= (x1+thick/2, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z8 = ( x3+ mw/4, (y2+y3)/2); %
z3 = ( x1 + 0.6mw, (y2+y4)/2.2);
z9 = ( x3+ mw/4, (y3+y4)/2); %
z4 = ( x2+ mw/4 , undershoot); % bottom middle
z5 = ( (x1+x3)/2.2, (y2 + y4)/2.5);
z6 =(x5 + mw/2, 0.8m);
z7 =(x6 + mw/2.5, 0.2m);

paths[p]:=z0..z1..z2 ..z8..{left}z3{dir 10}..z9..z4..z5.. z6..{down}z7   ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib )(1,2,3,4,5,6,7,8,9)
)(paths[p])(strokes[p]);

p:=p+1;
input ./glyphs/include/right_arch_with_tail;

endglyph;
