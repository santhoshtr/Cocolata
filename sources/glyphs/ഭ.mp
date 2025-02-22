input glyph;
beginglyph;

z0 = ( x1 + 0.15mw , 0);
z1 = ( 0, (y0 + y2)/2);
z2 = ( x1 + mw/2, m - overshoot); % top
z3 = ( x2 + mw/3, y4 + m/8);
z4= ( x3 - mw/5, y5 + m/7);
z5= ( x4 - mw/4, (y4 + y6)/2);
z6= ( x5 + mw/5, y7 + m/7);
z7 = ( x6 + mw/4, y8 + m/8);
z8 = ( x2 - mw/8, thick*0.6);

paths[p] := z0..z1{up}..z2{right}..z3{down}..z4{left}..z5{down}..z6{right}..z7{down}..{dir 150}z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(start_up_nib rotated terminalangle 0 of paths[p])(0)
    nib(middle_up_nib)(1)
    nib(top_nib)(2)
    nib(middledownnib)(3,5, 7)
    nib(top_nib scaled 0.8)(4, 6)
    nib(end_nib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

endglyph;
