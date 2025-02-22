input glyph;
beginglyph;

input ./glyphs/include/എ;

clearxy;
z0=(0, 0);
z1=((x0  + x2)/2, -descent*0.8);
z2=(x0 - mw/1.8,0);
z3=(x2, m/3);
z4=(x0, m-overshoot); % top
z5=(x0 + mw/2, y4 - m/2.5);
z6=(x5 - mw/3, y5 - m/3); % <
z7=(x0+mw/1.8, y6 - m/4);
z8=(x6, y7-m/4);

paths[3]:= z0{down}..z1{left}..{up}z2..z3{up}..z4{right}..z5{down}..{left}z6{right}..z7..z8;
paths[3]:= paths[3] shifted (xpart(point 0 of paths[2]), 0);
pen_stroke(
    nib(middle_down_nib rotated -10)(0,4)
    nib(middle_down_nib)(4)
    nib(down_nib)(1)
    nib(middleupnib)(2)
    nib(middle_up_nib)(3)
    nib(top_nib)(4)
    nib(end_nib rotated 90)(6)
    nib(middle_down_nib)(5,7)
    nib(end_nib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

endglyph;
