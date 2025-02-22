input glyph;
beginglyph;

input ./glyphs/include/ല;

anchor( "vc", point 0.5 of paths[p]);
anchor( "bottom", point infinity of paths[p]);

anchor( "right", (xpart point infinity of paths[p] - u_drop_sign_radius, u_drop_sign_vshift));

endglyph;