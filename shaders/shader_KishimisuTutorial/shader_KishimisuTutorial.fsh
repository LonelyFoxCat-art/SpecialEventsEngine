varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform float iTime;
uniform vec2 iResolution;

vec3 palette(float t) {
    const vec3 a = vec3(0.5);
    const vec3 b = vec3(0.5);
    const vec3 c = vec3(1.0);
    const vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = (v_vTexcoord * 2.0 - 1.0) * vec2(iResolution.x / iResolution.y, 1.0);
    vec2 uv0 = uv;
    float len0 = length(uv0);
    vec3 finalColor = vec3(0.0);

    for (int i = 0; i < 4; ++i) {
        uv = fract(uv * 1.5) - 0.5;
        float d = length(uv) * exp(-len0);
        vec3 col = palette(len0 + float(i) * 0.2 + iTime * 0.4);

        d = abs(sin(d * 8.0 + iTime)) / 8.0;
        d = pow(clamp(0.01 / (d + 1e-5), 0.0, 20.0), 1.2);

        finalColor += col * d;
    }

    gl_FragColor = vec4(finalColor, 1.0) * v_vColour;
}