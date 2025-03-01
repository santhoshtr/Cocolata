input glyph;
beginglyph;

input ./glyphs/include/സ;

for i = 2 upto 3:
    paths[i] := paths[i-2] shifted (0.56mw, -m) xscaled 0.8 yscaled 0.75;
    strokes[i] := strokes[i-2] shifted (0.56mw, -m) xscaled 0.8 yscaled 0.75;
endfor;

anchor( "vc", z3);
anchor( "right", (point 3 of paths[p]));
endglyph;
