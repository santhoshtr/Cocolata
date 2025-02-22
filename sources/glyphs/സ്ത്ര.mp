input glyph;
beginglyph;
input ./glyphs/include/സ;

for i=0 upto p:
    paths[i] := paths[i] shifted (mw/3, 0);
    strokes[i] := strokes[i] shifted (mw/3, 0);
endfor;

% Make room for ത്ര
paths[p] := paths[p] yscaled 0.9 shifted (0, 0.1m);
strokes[p] := strokes[p] yscaled 0.9 shifted (0, 0.1m);

p:=p+1;
clearxy;
%  ത്ര
input ./glyphs/include/ത;
paths[p] := paths[p] shifted (2mw, -0.95m) scaled 0.6;

clearxy;
z8 = (xpart point 4 of paths[p], -1.4*descent); % ra sign starts
z9 = (xpart point 1 of paths[p] -mw/6, 0);

cut:=6.8;
paths[p] := (subpath(0, cut) of paths[p]){dir angle(direction cut of paths[p])} .. {left}z8{left} .. {dir 50}z9;
dt := directiontime dir 90 of subpath( 8, 9) of paths[p];
paths[p] := insert_nodes(paths[p])(8 + dt);

paths[p] := paths[p] shifted (mw/3,0);
pen_stroke(
    nib(start_up_nib scaled 0.8 rotated terminalangle 0 of paths[p])(0)
    nib(top_nib scaled 0.8)(2,6)
    nib(middle_down_nib scaled 0.8)(3, 7)
    nib(down_nib scaled 0.8)(4)
    nib(middle_up_nib scaled 0.8)(1,5)
    nib(downnib scaled 0.8)(8)
    nib(endnib scaled 0.8)(9)
    nib(end_nib scaled 0.8 rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

anchor( "vc", (xpart point infinity of paths[0],0));

endglyph;
