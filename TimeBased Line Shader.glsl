/*{
"CREDIT": "Paulhh",
"DESCRIPTION": "TimeBased Line Shader",
"VSN": "1.3",
"TAGS": "line,graphic",
"INPUTS": [
{ "LABEL": "Cells/Cells X", "NAME": "mat_cells_x", "TYPE": "int", "MIN": 1, "MAX": 32, "DEFAULT": 1 },
{ "LABEL": "Cells/Cells Y", "NAME": "mat_cells_y", "TYPE": "int", "MIN": 1, "MAX": 32, "DEFAULT": 1 },
{ "LABEL": "Global/Line Width", "NAME": "mat_width", "TYPE": "float", "DEFAULT": 0.1, "MIN": 0.0, "MAX": 1.0 },
{ "LABEL": "Global/Repeat", "NAME": "mat_repeat", "TYPE": "int", "DEFAULT": 1, "MIN": 1, "MAX": 16 },
{ "LABEL": "Global/Polar Coord", "NAME": "mat_polar_coordinates", "TYPE": "bool", "DEFAULT": false, "FLAGS": "button" },
{ "LABEL": "Global/Symetry", "NAME": "mat_symetric", "TYPE": "bool", "DEFAULT": false, "FLAGS": "button" },
{ "LABEL": "Color/Front Color", "NAME": "mat_front_color", "TYPE": "color", "DEFAULT": [ 1.0, 1.0, 1.0, 1.0 ] },
{ "LABEL": "Color/Back Color", "NAME": "mat_back_color", "TYPE": "color", "DEFAULT": [ 0.0, 0.0, 0.0, 1.0 ] },
{ "LABEL": "Color/Brightness", "NAME": "mat_brightness", "TYPE": "float", "MIN": -1.0, "MAX": 1.0, "DEFAULT": 0.0 },
{ "LABEL": "Color/Contrast", "NAME": "mat_contrast", "TYPE": "float", "MIN": 1.0, "MAX": 3.0, "DEFAULT": 1 },
{ "LABEL": "Time/Duration", "NAME": "mat_duration", "TYPE": "float", "MIN": 0.0, "MAX": 60.0, "DEFAULT": 5.0 },
{ "LABEL": "Edge/Edge Softness", "NAME": "mat_edge_softness", "TYPE": "float", "MIN": 0.0, "MAX": 1.0, "DEFAULT": 0.0 },
{ "LABEL": "Translation/Translate X", "NAME": "mat_translate_x", "TYPE": "float", "MIN": -1.0, "MAX": 1.0, "DEFAULT": 0.0 },
{ "LABEL": "Translation/Reverse Direction", "NAME": "mat_reverse_direction", "TYPE": "bool", "DEFAULT": false, "FLAGS": "button" }
],
"GENERATORS": [
{
"NAME": "mat_time",
"TYPE": "time_base",
"PARAMS": { "speed": 1.0, "speed_curve": 2, "bpm_sync": false, "link_speed_to_global_bpm": false }
}
]
}*/

#ifndef M_PI
#define M_PI 3.1415926535897932384626433832795
#endif

#include "MadNoise.glsl"

vec4 materialColorForPixel(vec2 texCoord)
{
// Berechne Fortschritt basierend auf aktueller Zeit und Duration
float timeProgress = min(1.0, max(0.0, mat_time / mat_duration));

// Setze die Translation, um die Linie von links nach rechts zu bewegen
float translateX = mat_translate_x + (mat_reverse_direction ? -timeProgress : timeProgress);

// Setze Center und Translation
mat3 linePatternsMatrix = mat3(1, 0, -0.5 + translateX,
0, 1, -0.5,
0, 0, 1);

vec2 p = texCoord;
vec2 cellSize = vec2(1.0 / mat_cells_x, 1.0 / mat_cells_y);
p = mod(p, cellSize) / cellSize;
if (mat_polar_coordinates)
{
vec2 x = p - vec2(0.5);
p.x = length(x);
p.y = atan(x.y, x.x) * 0.5 / M_PI + 0.5;
}

// Änderung hier: Invertiere die Linienbreite
float halfFinalWidth = (1.0 - mat_width) * 0.5;

vec2 uv = (vec3(p, 1) * linePatternsMatrix).xy;
float dist = fract(uv.x) - 0.5;

float value;
if (abs(dist) < halfFinalWidth)
{
value = 1;
}
else
{
value = 0;
}

// Apply edge softness
value = smoothstep(-mat_edge_softness + halfFinalWidth, mat_edge_softness + halfFinalWidth, abs(dist));

vec4 finalColor = mix(mat_back_color, mat_front_color, value);
finalColor.rgb = mix(finalColor.rgb, 1 - finalColor.rgb, mat_brightness);
finalColor.rgb = mix(vec3(0.5), finalColor.rgb, mat_contrast);

return finalColor;
}
