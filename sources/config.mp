% This file is the base configuration for the font
% Variant configuration overrides the config variables defined here.
% Copyright 2025 Santhosh Thottingal
% Licensed under MIT License

em :=           1000;         % Height of characters - Em square
u :=            em/10;        % Unit width. Em square divisions. This is the base for all strokes

ascent  :=      7u;         % Ascender Height
descent :=      3u;         % Descender Height
xheight :=      0.62*ascent;  % Height of English small letters
mheight :=      0.62*ascent;  % Height of Malayalam letters
Xheight :=      0.94*ascent;  % Height of English capital letters

rotation :=     45;           % Angle of calligraphic pen
thick :=        1u;           % Thickness of thickest lines
contrast :=     0.56;         % 1 - thin/thick. 0 for monolinear. 0.9 for high contrast
slant :=        0;            % Slant of characters.Give angle values
condense :=     1;            % Condense factor. Less than for condense, Greater than one for expand

linecap :=      butt;         % butt or rounded or square
linejoin :=     rounded;      % rounded or mitered or beveled
soften :=       0;            % Whether sharp corners need to be softened using cornerradius
cornerradius := 10;           % Corner radius. Used when soften=1.
terminalround:= 0;            % Terminal roundness. Give 1 for round terminals. 0 for razor cuts

outputformat := "svg";        % Output format

varstroke :=     1;           % Stroke modulation. Uses pen_strokes
harmonize_curves:=1;        % Harmonize curves or not

color glyphcolor; glyphcolor :=(3,105,161)/255;
color debugcolor; debugcolor := (224,242,254)/255;
color pathcolor; pathcolor := (240,249,255)/255;
color pointcolor; pointcolor := (249,115,22)/255;
color precontrolcolor; precontrolcolor := (52,211,153)/255;
color postcontrolcolor; postcontrolcolor := (99,102,241)/255;
color gridcolor; gridcolor :=  (240,249,255)/255;


% Configurations for debug(development) mode.
showgrids := 0;
showcoords := 0;
showcontrols:=0;
showpoints:=0;
show_paths := 0;


