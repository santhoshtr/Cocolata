input glyph;
beginglyph;

input ./glyphs/include/ല;

clearxy;
p:=p+1;
input ./glyphs/include/പ;

xshift := 0.1mw;
yshift := -0.65m;

paths[p-1] := paths[p-1] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;
strokes[p-1] := strokes[p-1] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;

paths[p] := paths[p] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;
strokes[p] := strokes[p] shifted (xshift, yshift) xscaled 0.9 yscaled 0.8;

anchor( "vc", point 0.5 of paths[p]);
anchor( "bottom", point 1 of paths[p]);
anchor( "right", (point 1 of paths[p]- (u_drop_sign_radius, 0)));

endglyph;
