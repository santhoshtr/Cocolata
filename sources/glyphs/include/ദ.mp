z0 = ( x1 + mw/8 , 0);
z1 = ( 0, (y0 + y2)/2);
z2 = ( x1 + mw/2, m-overshoot); % top
z3 = ( x2 + mw/3, y2 - m/4);
z4 = ( x3 - mw/3, y3 - m/4); % <
z5 = ( x3+ thick/4, y4-m/4);
z6 = ( x4, thin/2);
paths[p] =z0..z1{up}..{right}z2..z3..{left}z4{right}..z5{down}..{dir 150}z6;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(start_up_nib rotated terminalangle 0 of paths[p])(0)
    nib(middle_up_nib)(1)
    nib(top_nib)(2)
    nib(end_nib rotated 90)(4)
    nib(middle_down_nib)(5)
    nib(end_nib rotated terminalangle 6 of paths[p])(6)
)(paths[p])(strokes[p]);


pair point_offset, pre_offset, post_offset;
point_offset := (-mw/20, 0);
pre_offset := (0, 0);
post_offset := (0, 0);

strokes[p]:=edit_path(strokes[p], 10, point_offset, pre_offset,post_offset);
point_offset := (0, 0);
pre_offset := (0, -mw/20);
post_offset := (0, 0);
strokes[p]:=edit_path(strokes[p], 11, point_offset, pre_offset,post_offset);

