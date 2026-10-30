input glyph;
beginglyph;
paths[p] := pa_mouth shifted (mw/3, 0);
pen_stroke(
    nib(thicknib)(0, 1, 2, 3, 4, 5)
)(paths[p])(strokes[p]);

clearxy;
p:=p+1;
% The bar starts where the mouth stroke ends.
z0=point infinity of paths[p-1];
z1=z0 + (0.8mw + thick/4, 0);
paths[p]:= z0--z1 ;

pen_stroke(
    nib(thicknib)(0, 1)
)(paths[p])(strokes[p]);


p:=p+1;
input ./glyphs/include/റ;
xshift = xpart(point 1 of paths[p-1]) - mw/4;
paths[p] := paths[p]  shifted (xshift, 0);
paths[p] := (subpath(0, 3) of paths[p]);

clearxy;
z8 = (xpart point 1 of paths[p-1], reph_sign_depth); % ra sign starts
z9 = (xpart point 0 of paths[p-1], y8); % ra sign starts
z10 = (xpart point 1 of paths[p-2]- mw/6, m);

% Continue in the direction of the curve at node 3. A corner there gives
% the bold masters one more outline segment, and the masters do not
% interpolate.
paths[p] := (subpath(0, 3) of paths[p]) {direction 3 of paths[p]}.. z8---z9.. {dir 60}z10;
dt = directiontime dir 270 of subpath( 2, 4) of paths[p];
paths[p] := insert_nodes(paths[p])(2 + dt );
dt := directiontime dir 90 of subpath( 5, 6) of paths[p];
paths[p] := insert_nodes(paths[p])(5 + dt);
paths[p]:=harmonize(paths[p]);
pen_stroke(
    nib(thicknib rotated terminalangle 0 of paths[p])(0)
    nib(thicknib)(1, 2, 3, 4, 5, 6, 7)
    nib(thicknib rotated terminalangle infinity of paths[p])(infinity)
)(paths[p])(strokes[p]);

anchor( "vc", point 0.5 of paths[1]);
anchor( "right", (xpart point 3.6 of paths[p], ypart point 3.75 of paths[p]));

endglyph;
