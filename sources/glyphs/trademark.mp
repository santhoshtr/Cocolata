input glyph;
beginglyph;
z0=(Xw/3, X - thick/4);
z1=(x0, y0- .5X);
z2=(x1, 0);
z3 = (0, y0-thick/4) ;
z4 = (x0 + Xw/3, y3) ;
paths[0] = (z0{down}..z1..{down}z2) xyscaled(0.5, 0.5) shifted (0,0.8s);
paths[1] = (z3..z4) xyscaled(0.5, 0.5) shifted (0,0.8s);
pen_stroke(
    nib(thinnib)(0, 1, 2, infinity)
)(paths[0])(strokes[0]);
pen_stroke(
    nib(thinnib)(0, infinity)
)(paths[1])(strokes[1]);
clearxy;
z0= (thick/2, X);
z1=( x0, X/2);
z2=( x1, 0);
z3 = (x0, y0);
z4 = (x3 + 0.66X/2, 0.33X);
z5 = (x4, y4);
z6 = (x4 +  0.66X/2, y0);
z7 = (x6, y1);
z8 = (x7, y2);

paths[2] = (z0{down}..z1..{down}z2) xyscaled(0.5, 0.5) shifted (0.6s,0.8s);
paths[3] = (z3..z4) xyscaled(0.5, 0.5) shifted (0.6s,0.8s);
paths[4] = (z5..z6) xyscaled(0.5, 0.5) shifted (0.6s,0.8s);
paths[5] = (z6{down}..z7..{down}z8) xyscaled(0.5, 0.5) shifted (0.6s,0.8s);
pen_stroke(
    nib(thinnib)(0, 1, infinity)
)(paths[2])(strokes[2]);
pen_stroke(
    nib(thinnib)(0, 1, 2, infinity)
)(paths[3])(strokes[3]);
pen_stroke(
    nib(thinnib)(0, 1, 2, infinity)
)(paths[4])(strokes[4]);
pen_stroke(
    nib(thinnib)(0, 1, infinity)
)(paths[5])(strokes[5]);
endglyph;
