input glyph;
beginglyph;


clearxy;
z0 = (x1 + thick/2 , 0.85m);
z1 = (mw/3, (y0+y2)/2);
z2 = (x1 + mw/3, undershoot);
z3 = (x2 + mw/4, (y2 + y4)/2);
z4 = (x3 + mw/4, 0.9m);
z5 = (x4 + mw/2.5, y1);
z6 = (x3 , reph_sign_depth);
z7 = (0, y1);
z8 = (x7 + mw/8, y0);

paths[p] = z0{dir -110} ..z1 ..z2{dir 30} ..z3 ..z4{dir 30}..z5 ..z6..z7..z8;
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib )(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3)
    nib(thicknib)(4)
    nib(thicknib)(5,6)
    nib(thicknib)(7, 8)
)(paths[p])(strokes[p]);

anchor( "right",  point 5.6 of paths[p]) ;
endglyph;
