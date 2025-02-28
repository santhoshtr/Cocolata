input glyph;
beginglyph;

input ./glyphs/include/വ;


anchor( "vc", (xpart(point 2 of paths[0]),0));
anchor( "bottom", (xpart(point 4 of paths[p]),0));
anchor( "right", (xpart point 4 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift) );

endglyph;
