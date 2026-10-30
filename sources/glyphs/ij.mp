input glyph;
beginglyph;

input ./include/dotlessi;

% The dot of i
p:=p+1;
clearxy;
z0=(xpart point 1 of strokes[p-1], 0.9X);
z1=(x0+0.15s, y0-0.08X);
paths[p] = z0..z1..cycle;
strokes[p] = paths[p];

% j
clearxy;
p:=p+1;
input ./include/dotlessj;

paths[p] := paths[p] shifted (3*thick, 0);
strokes[p] := strokes[p] shifted (3*thick, 0);

% The dot of j
p:=p+1;
clearxy;
z0=(xpart point 1 of strokes[p-1], 0.9X);
z1=(x0+0.15s, y0-0.08X);
paths[p] = z0..z1..cycle;
strokes[p] = paths[p];

lbearing:=thick*condense*0.3;
rbearing:=thick*condense*0.3;

endglyph;
