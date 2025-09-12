input glyph;
beginglyph;

input ./glyphs/include/പ;


for p = 2 upto 3:
    paths[p] := paths[p-2] shifted (0.3mw, -0.7m) xscaled 0.8 yscaled 0.75;
    strokes[p] := strokes[p-2] shifted (0.3mw, -0.7m) xscaled 0.8 yscaled 0.75;
endfor;


anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "bottom", point 1 of paths[3]);
anchor( "right", (point 1 of paths[3] - (u_drop_sign_radius, 0)));

endglyph;
