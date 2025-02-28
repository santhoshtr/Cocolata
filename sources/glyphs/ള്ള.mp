input glyph;
beginglyph;

clearxy;
z0 =(thick, (y1 + y3)/1.75);
z1 =(x0 + mw/4, y3+0.5m);
z2=(x1 + mw/4, (y1 + y3)/2);
z3=(x2 - mw/4, undershoot);
z4=(0, (y1 + y3)/2);
z5=(x4 + mw/2, 0.9m);
z6 = (x5+ mw/2, (y5+y7)/2); %
z7=(x6 - mw/6, 0.4m);
z9=(x7+ mw/4, 0.1m);
z10=(x1, -descent/2);
z11=(x9 + thick, y10);
% Dummy path
paths[p] = z0 ..z1..z2..z3..z4{dir 100}..  z5{right}..{down}z6;
% Get the point for extrema
z8=point 4.1 of paths[p];
paths[p] := z0{dir 80}..z1..z2..z3..z8{up}..z5{dir 10}
    ..z6..{left}z7{right} ..z9..{dir 190}z10{right}..z11;
pen_stroke(
   nib(thicknib)(0, 1, 2, 3,4,5,6,7,8,9,10,11)
)(paths[p])(strokes[p]);
rbearing:=-thick;

clearxy;
p:=p+1;
xshift:=xpart point infinity of paths[p-1] ;
paths[p] = paths[p-1] shifted(xshift,0);
strokes[p] = strokes[p-1] shifted(xshift,0);

anchor( "vc", (xpart(point 0 of paths[p]),0));
anchor( "right", (xpart point 10 of paths[p] - u_drop_sign_radius, ypart point 11 of strokes[p] + u_drop_sign_vshift));

endglyph;
