input glyph;
beginglyph;
clearxy;
z0= (x1+thick/2, undershoot);
z1= (0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2.5, 0.9m); % top
z3 = ( x1 + 0.9mw, (y2+y4)/1.6);
z4 = ( x2+ mw/4 , 0); % bottom middle
z5 = ( (x1+x3)/2.2, m/2);
z6 =(x5 + mw/2, 0.85m);
z7 =(x6 + mw/2.5, 0.3m);
z8 = (x7 + mw/3, undershoot);
z9 = (x7 + mw, 0.5m);
z10 = (x9 - mw/4, 0.9m);
z11 = (x10 - mw/3 , 0.2m);

paths[p]:=z0..z1..z2{right}..z3..z4..z5..z6..{dir 260}z7..z8..z9..z10..{dir 285}z11;
paths[p] :=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2,3,4,5,6,7,8,9,10,11)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart( point 4 of paths[p]),0));
anchor( "right", (xpart(point 0 of paths[p]) - u_drop_sign_radius, u_drop_sign_vshift));

endglyph;
