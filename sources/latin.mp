% This file contains reusable, common glyph shapes for Latin script
% for the current font.
% Copyright 2025 Santhosh Thottingal
% Licensed under MIT License

vardef a_loop =
    clearxy;
    save r;
    r=0.85;
    z0=(sw*r,  s-thick);
    z1=(0.5*sw*r, s-overshoot);
    z2=(0, s/3);
    z3=(r*sw/3, undershoot);
    z4=(x0, y0);
    harmonize(z0..z1{dir 190}..{dir -80}z2{dir -80}..z3..{dir 80}z4)
enddef;

vardef circle(expr radius) =
    clearxy;
    z0 = (0, radius/2);
    z1 = ((x0 + x2)/2, radius);
    z2 = (x0 + radius, y0);
    z3 = (x1, 0);
    z4 = (x0, y0);
    z0{up}..{right}z1..{down}z2..z3{left}..cycle
enddef;