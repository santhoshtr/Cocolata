input glyph;
beginglyph;

input ./glyphs/include/സ;

for p = 2 upto 3:
    paths[p] := paths[p-2] shifted (0.56mw, -m) xscaled 0.8 yscaled 0.75;
    strokes[p] := strokes[p-2] shifted (0.56mw, -m) xscaled 0.8 yscaled 0.75;
endfor;

anchor( "vc", point 3 of paths[0]);
anchor( "right", point 3 of paths[3]);
endglyph;
