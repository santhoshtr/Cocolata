input glyph;
beginglyph;
paths[0] = fullcircle scaled (thick*1.5) shifted(thick, X);
paths[1] = paths[0] shifted(sw/2, 0);
strokes[0] = paths[0];
strokes[1] = paths[1];
anchor( "top", (0, X));
endglyph;
