input glyph;
beginglyph;
input ./glyphs/include/left_arch;

p:=p+1;
clearxy;
input ./glyphs/include/right_arch;


p:=p+1;
clearxy;
z0=(0, 0);
z1=(mw, y0);
z2=(x1+mw/4, m/2);
z3=((x2+x4)/2, m-overshoot);
z4=(x1- mw*0.4, y2);
z5=(x4, ypart(point infinity of paths[p-1]));
paths[p]= z0..{dir 10}z1..z2..z3..z4..{down}z5 ;
paths[p]:=paths[p] shifted ( point infinity of paths[p-1] + (thin*1.2/2, thick*thin_horizontal_nib_scale/2) );
pen_stroke(
    nib(thicknib)(0)
    nib(thicknib)(1)
    nib(thicknib)(2)
    nib(thicknib)(3,4)
)(paths[p])(strokes[p]);

anchor( "right", (xpart point 2 of paths[p] - u_drop_sign_radius,u_drop_sign_vshift));
endglyph;
