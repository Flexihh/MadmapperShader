/*{
"CREDIT": "Paulhh",
"DESCRIPTION": " Line Shader",
"VSN": "1.3",
"TAGS": "line,graphic",
"INPUTS": [
{ "LABEL": "Time/Duration", "NAME": "mat_duration", "TYPE": "float", "MIN": 0.0, "MAX": 60.0, "DEFAULT": 5.0 },
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

vec4 materialColorForPixel(vec2 texCoord)
{
// Berechne Fortschritt basierend auf aktueller Zeit und Duration
float timeProgress = min(1.0, max(0.0, mat_time / mat_duration));

// Setze die Translation, um die Linie von links nach rechts zu bewegen
float translateX = (mat_reverse_direction ? 1.0 - timeProgress : timeProgress); // Änderung hier

vec2 p = texCoord;
vec2 cellSize = vec2(1.0, 1.0);
p = p / cellSize;

vec2 uv = (vec3(p, 1) * mat3(1, 0, -0.5 + translateX, 0, 1, -0.5, 0, 0, 1)).xy;
float dist = uv.x - 0.5;

float value;
if (abs(dist) < 0.01)
{
value = 1;
}
else
{
value = 0;
}

vec4 finalColor = mix(vec4(0.0, 0.0, 0.0, 1.0), vec4(1.0, 1.0, 1.0, 1.0), value);

return finalColor;
}
