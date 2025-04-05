input glyph;
beginglyph;

z0= (x1 + thick/2, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/4 ,undershoot); % bottom middle
z5 = ( (x1+x3)/2.2, m/2);
z6 =(x5 + mw/2, 0.85m);
z7 =(x6 + mw/2.5, 0.5m);
z8 =(x7 - mw/2,  -descent*0.8);
z9 = (x8 - mw/3, (y8+y10)/2);
z10= (x8, y9+m/6);
z11= (x8 + mw/4, y9);

paths[p]:=z0...z1..z2..z3...z4..z5..z6...z7..z8{left}..z9{up}..z10..z11;  ;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11,12)
)(paths[p])(strokes[p]);

anchor( "vc", point 4 of paths[0]);
endglyph;
