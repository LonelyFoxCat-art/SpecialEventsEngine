varying vec2 v_vTexcoord;
uniform float u_quantize;
uniform float u_edge_threshold;
uniform float u_edge_color;
uniform float u_paper_strength;
uniform vec2 u_texture_size;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    vec2 uv = v_vTexcoord;
    vec4 color = texture2D(gm_BaseTexture, uv);

    // —————— 色阶量化 ——————
    vec3 quantized = floor(color.rgb * u_quantize) / u_quantize;

    // —————— 边缘检测 ——————
    vec2 px = 1.0 / u_texture_size;

    float left   = texture2D(gm_BaseTexture, uv + vec2(-px.x, 0.0)).r;
    float right  = texture2D(gm_BaseTexture, uv + vec2( px.x, 0.0)).r;
    float up     = texture2D(gm_BaseTexture, uv + vec2(0.0, -px.y)).r;
    float down   = texture2D(gm_BaseTexture, uv + vec2(0.0,  px.y)).r;
    float ul     = texture2D(gm_BaseTexture, uv + vec2(-px.x, -px.y)).r;
    float ur     = texture2D(gm_BaseTexture, uv + vec2( px.x, -px.y)).r;
    float dl     = texture2D(gm_BaseTexture, uv + vec2(-px.x,  px.y)).r;
    float dr     = texture2D(gm_BaseTexture, uv + vec2( px.x,  px.y)).r;

    float gx = -ul - 2.0 * left - dl + ur + 2.0 * right + dr;
    float gy = -ul - 2.0 * up   - ur + dl + 2.0 * down + dr;
    float edge = sqrt(gx * gx + gy * gy);

    float edge_factor = smoothstep(u_edge_threshold, u_edge_threshold + 0.05, edge);
    vec3 final_color = mix(quantized, vec3(0.0), edge_factor * u_edge_color);

    // —————— 纸张噪点 ——————
    if (u_paper_strength > 0.0) {
        float noise = rand(uv * 300.0 + u_paper_strength);
        final_color *= (0.95 + 0.05 * noise);
    }

    gl_FragColor = vec4(final_color, color.a);
}