input glyph;
beginglyph;
clearxy;
% ഋ sign
z0 = (0, 0.9m);
z1 = (x0 - mw/2, -descent );
z2 = (x1 - mw/3, y1+m/4);
z3 = (x1 + mw/3, y2);
paths[p] = z0{dir -80}.. {left}z1..{dir 45}z2.. z3;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib)(0,1,2,3 )
)(paths[p])(strokes[p]);

absolute_position := 1;
endglyph;
