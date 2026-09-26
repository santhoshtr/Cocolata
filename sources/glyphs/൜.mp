% ൜ U+0D5C MALAYALAM FRACTION ONE TENTH
% rantumaa
input glyph;
beginglyph;
z0=(x1+mw/3, 0);
z1=(0, y0 + m/2);
z2=(x1 + mw/3, m-overshoot);
z3=(x2 + mw/4, m/2);
z4=(x3 + mw/4, undershoot);
z5=(x4 + mw/4, m/2);
z6=(x5 + mw/4, m-overshoot);
z7=(x6 + mw/4, m/2);
z8=(x7 + mw/4, undershoot);
z9=(x8 + mw/3, m/2);
z10=(x9-mw/4 , m);

paths[0] = z0..z1{up}..z2{right}..z3{down}..z4{right}..z5{up}..z6{right}..z7{down}..z8{right}..z9{up}..z10 ;
pen_stroke(
    nib(thicknib)(0,1,2,3,4,5,6,7,8,9,10)
)(paths[0])(strokes[0]);


endglyph;
