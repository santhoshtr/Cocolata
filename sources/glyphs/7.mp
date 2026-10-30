input glyph;
beginglyph;

% Top bar
z0=(0, 0.89X );
z1=(x0 + .59Xw, 0.95X);
z2=((x0+x1)/2 , 0);

paths[p] = z0{dir 10}..{right}z1{dir 235}..z2;
pen_stroke(
    nib(thicknib)(0,1,2, 3)
)(paths[p])(strokes[p]);

endglyph;
