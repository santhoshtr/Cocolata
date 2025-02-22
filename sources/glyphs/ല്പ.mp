input glyph;
beginglyph;

input ./glyphs/include/ല;

clearxy;
p:=p+1;
input ./glyphs/include/പ;

xshift := 0.175mw;
yshift := -0.75m;


paths[p] := paths[p] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;
strokes[p] := strokes[p] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;



anchor( "vc", point 0.5 of paths[p]);
anchor( "right", (xpart point 0 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift) );

endglyph;