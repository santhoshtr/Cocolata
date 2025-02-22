input glyph;
beginglyph;
z0 = ( x1 + mw/4 , 0);
z1 = ( 0, (y0 + y2)/2);
z2 = ( (x1 + x3)/2, m - overshoot); % top
z3 = ( x1 + mw, (y2 + y4)/2);
z4 = ( x3 - mw/4, (y2 + y6)/2.1 ); % <
z5 = ( x4 + mw/3, (y4 + y6)/2);
z6 = ( (x5 + x7)/2, undershoot);
z7 = ( x5 - 2/3mw, (y6+y8)/2.25);
z8 = ( (x7 + x9)/2, m - overshoot*1.25);   % top
z9 = ( x7 + mw, 0.6m);
z10 = ( x9, 0);
paths[p] = z0..z1{up}..z2{right}..z3{down}..{left}z4{right}..z5{down}..z6 ..z7{up}..z8{right}..{down}z9---z10;

pen_stroke(
    nib(start_up_nib rotated terminalangle 0 of paths[p])(0)
    nib(middle_up_nib)(1)
    nib(topnib)(2)
    nib(thin_vertical_nib rotated 90)(4)
    nib(thicknib)(3, 5)
    nib(downnib)(6)
    nib(middleupnib)(7)
    nib(topnib)(8)
    nib(thicknib)(9)
    nib(thick_vertical_nib)(10)
)(paths[p])(strokes[p]);



pair point_offset, pre_offset, post_offset;
point_offset := (-mw/20, 0);
pre_offset := (0, 0);
post_offset := (0, 0);

strokes[p]:=edit_path(strokes[p], 18, point_offset, pre_offset,post_offset);

clearxy;
p:=p+1;
input ./glyphs/include/right_arch_with_eye;

endglyph;
