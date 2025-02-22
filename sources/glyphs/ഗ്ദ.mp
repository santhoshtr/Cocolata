input glyph;
beginglyph;
input ./glyphs/include/ഗ;

paths[p] := subpath (0, 4) of paths[p];
clearxy;
z5 = point 4 of paths[p];
z6 = (x5 + mw/3, (y5+y7)/2);
z7 = (x6 - mw/3, (y6+y8)/2);
z8 = (x6 + thick/4, (y7+y9)/2);
z9 = (x7, thin/2);
paths[p] := paths[p]{right}.. z6{down}..{left}z7{right}..z8{down}..{dir 160}z9;
paths[p]:=harmonize(paths[p]);
pen_stroke(
   nib(end_nib rotated terminalangle 0 of paths[p])(0)
   nib(middle_up_nib scaled 1.2 rotated 30)(1)
   nib(downnib)(2)
   nib(middledownnib)(3)
   nib(middle_down_nib)(5, 7)
   nib(topnib)(4)
   nib(end_nib rotated 90)(6)
   nib(end_nib rotated terminalangle 6 of paths[p])(9)
)(paths[p])(strokes[p]);

pair point_offset, pre_offset, post_offset;
point_offset := (-mw/20, 0);
pre_offset := (0, 0);
post_offset := (0, 0);

strokes[p]:=edit_path(strokes[p], 12, point_offset, pre_offset,post_offset);

anchor( "vc", point 3 of paths[p]);
anchor( "right", point 7.75 of paths[p]);
endglyph;
