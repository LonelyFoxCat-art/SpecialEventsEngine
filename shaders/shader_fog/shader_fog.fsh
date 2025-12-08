varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform float u_density;
uniform float u_detail_scale;
uniform vec2  u_resolution;

// ──────────────── 2D Simplex Noise (Stefan Gustavson / Ashima Arts) ────────────────
vec2 mod289_vec2(vec2 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 mod289_vec3(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 permute_vec2(vec2 x) {
    return mod289_vec2(((x * 34.0) + 1.0) * x);
}

vec3 permute_vec3(vec3 x) {
    return mod289_vec3(((x * 34.0) + 1.0) * x);
}

float simplex_noise2d(vec2 v) {
    const vec4 C = vec4(0.211324865405187,  // (3.0 - sqrt(3.0)) / 6.0
                        0.366025403784439,  // 0.5 * (sqrt(3.0) - 1.0)
                       -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0

    // Skew the input space to determine which simplex cell we're in
    vec2 i = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);

    // Determine the other two corners of the simplex
    vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

    // Permutations
    i = mod289_vec2(i);
    vec3 p = permute_vec3(permute_vec3(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));

    // Gradients: 41 points uniformly over a line
    vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
    m = m * m;
    m = m * m;

    // Compute final noise value at P
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);

    // Compute dot products
    vec3 g;
    g.x = a0.x * x0.x + h.x * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;

    return 130.0 * dot(m, g);
}

// ──────────────── Dynamic FBM using 2D Simplex (no translation, phase drift only) ────────────────
float dynamic_fbm2d(vec2 uv) {
    float value = 0.0;
    float amplitude = 0.65;

    // Layer 1: large scale, slow phase drift
    vec2 phase1 = vec2(sin(u_time * 0.45 + 0.0) * 1.8, cos(u_time * 0.45 + 0.0) * 1.8);
    value += amplitude * simplex_noise2d(uv * 0.75 + phase1);
    amplitude *= 0.5;

    // Layer 2: medium scale, medium speed
    vec2 phase2 = vec2(sin(u_time * 0.85 + 1.2) * 1.3, cos(u_time * 0.85 + 1.2) * 1.3);
    value += amplitude * simplex_noise2d(uv * 1.6 + phase2);
    amplitude *= 0.5;

    // Layer 3: fine detail, fast drift
    vec2 phase3 = vec2(sin(u_time * 1.7 + 2.5) * 0.9, cos(u_time * 1.7 + 2.5) * 0.9);
    value += amplitude * simplex_noise2d(uv * 3.2 + phase3);

    return value;
}

// ──────────────── Main Function ────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution * u_detail_scale;

    float fog_raw = dynamic_fbm2d(uv);
    float fog = fog_raw * 0.5 + 0.5;

    fog = pow(fog, 1.65);
    fog = fog * u_density;
    fog = clamp(fog, 0.0, 1.0);

    vec3 fog_color = vec3(1.0, 1.0, 1.0);

    gl_FragColor = vec4(fog_color, fog) * v_vColour;
}