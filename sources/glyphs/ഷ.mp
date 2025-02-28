input glyph;
beginglyph;

input ./glyphs/include/ഷ.mp;

anchor( "vc", point 0.5 of paths[p]);

anchor( "right", (xpart point 4 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift) );

endglyph;
