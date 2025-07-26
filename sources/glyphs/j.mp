input glyph;
beginglyph;

z0=(x3, s-overshoot);
z1=(x2, s-overshoot);
z2=(x3 + 0.4sw , 0.8*-descent);
z3=(-0.2sw, y2 + s/4);
paths[p] =  z1{dir -80}...z2..{up}z3;

pen_stroke(
     nib(thicknib)(0,1,2,3,4)
)(paths[p])(strokes[p]);



p:=p+1;
clearxy;
z0=(xpart point 1 of strokes[p-1], 0.9X);
z1=(x0+0.15s, y0-0.08X);
paths[p] = z0..z1..cycle;
strokes[p]:=paths[p];

absolute_position := 1;

endglyph;
