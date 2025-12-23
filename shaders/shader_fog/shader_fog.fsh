varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform float iTime;
uniform vec2 iResolution;

const vec3 COLOR = vec3(0.42, 0.40, 0.47);
const vec3 BG = vec3(0.0);
const float ZOOM = 3.0;
const float INTENSITY = 2.0;

vec2 hash2(vec2 p) {
    p = fract(p * vec2(127.1, 311.7));
    p += dot(p, p + 33.33);
    return fract((p.xx + p.yy) * p);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);

    vec2 a = hash2(i);
    vec2 b = hash2(i + vec2(1.0, 0.0));
    vec2 c = hash2(i + vec2(0.0, 1.0));
    vec2 d = hash2(i + vec2(1.0, 1.0));

    float n0 = dot(a - 0.5, f - vec2(0.0, 0.0));
    float n1 = dot(b - 0.5, f - vec2(1.0, 0.0));
    float n2 = dot(c - 0.5, f - vec2(0.0, 1.0));
    float n3 = dot(d - 0.5, f - vec2(1.0, 1.0));

    return mix(mix(n0, n1, u.x), mix(n2, n3, u.x), u.y);
}

float fbm(vec2 p, int octaves) {
    float value = 0.0;
    float amp = 0.5;
    for (int i = 0; i < octaves; ++i) {
        value += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return value;
}

void main() {
    vec2 uv = v_vTexcoord * iResolution.xy / iResolution.y;
    vec2 pos = uv * ZOOM;

    vec2 motion = vec2(
        fbm(pos + vec2(-0.5 * iTime, -0.3 * iTime), 4),
        fbm(pos + vec2(-0.3 * iTime, -0.5 * iTime), 4)
    );

    float final = fbm(pos + motion, 4) + 0.2;
    final *= INTENSITY;

    vec3 color = mix(BG, COLOR, final);
    gl_FragColor = vec4(color, 1.0) * v_vColour;
}