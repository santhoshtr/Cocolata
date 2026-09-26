% ൝ U+0D5D MALAYALAM FRACTION THREE TWENTIETHS
% muunnumaa
input glyph;
beginglyph;
z0=(0,0);
z1=(x0 + mw/3, m/4);
z2=(x1, m);
z3=(x2, m/2);
z4=(x3 + mw/3, undershoot);
z5=(x4 + mw/4, y0 + m/2);
z6=(x5 + mw/4, m-overshoot);
z7=(x6 + mw/4, m/2);
z8=(x7 + mw/4, undershoot);
z9=(x8 + mw/4, m/2);
z10=(x9 + mw/4, m-overshoot);
z11=(x10 + mw/4, m/2);
z12=(x11 + mw/4, undershoot);
z13=(x12 + mw/4, m/2);
z14=(x13 - mw/4 , m);

paths[0] = z0..z1---z2;
pen_stroke(
      nib(thicknib)(0,1,2)
)(paths[0])(strokes[0]);


paths[1]= z2---z3{down}..z4{right}..z5{up}..z6{right}..z7{down}..z8{right}..z9{up}..z10{right}..z11{down}..z12{right}..z13{up}..z14 ;

pen_stroke(
      nib(thicknib)(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14)
)(paths[1])(strokes[1]);

endglyph;
