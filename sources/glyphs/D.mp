input glyph;
beginglyph;


% vertical stem
z0=(mw/6, 0.9X);
z1=(x0 , 0.1X);

paths[p] := z0{dir -90}...{dir -85}z1;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
z0=(0, 0.95X);
z1=(x0 + 0.6Xw, 0.6X);
z2=(x0 + 0.4Xw, 0.2s );
z3=point 1 of paths[0];

paths[p] = z0{dir 10}..z1..{dir 190}z3;
pen_stroke(
   nib(thicknib)(0,1)
)(paths[p])(strokes[p]);

anchor( "top", (xpart(point 1 of paths[1]), 1.1X));
anchor( "bottom", (xpart(point 1 of paths[1]), 0));
endglyph;
