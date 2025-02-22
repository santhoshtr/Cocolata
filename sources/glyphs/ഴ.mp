input glyph;
beginglyph;

z0 = (x1 +  thick*0.75 , m);
z1 = (0, (y0 + y2)/2.1);
z2 = ((x1 + x3)/2, 0.3m);
z3 = (x2 + mw/2, (y2 + y4)/1.9);
z4 = ((x3 + x5)/2, m-overshoot);
z5 = (x4 - mw/3.5, y4 - .25m);
z6 = (x5 + mw/8, y7 + 0.25m);
z7 = ((x5+x7)/2.2, -2undershoot);
z8 = (x6 - mw/1.75, y7+ 0.15m);
paths[p] = z0{dir 220}..z1..z2{right}..z3{up}..z4{left}..z5{down}..z6..z7{left}..z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(end_nib rotated terminalangle 0 of paths[p])(0)
    nib(middledownnib)(1)
    nib(downnib)(2)
    nib(middleupnib)(3)
    nib(topnib)(4)
    nib(middledownnib)(5,6)
    nib(downnib)(7)
    nib(end_nib scaled 3/4 rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

anchor( "vc", (x4,0));
anchor( "right", point 10.5 of strokes[p] );

endglyph;

