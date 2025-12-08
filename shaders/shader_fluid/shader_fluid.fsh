varying vec2 v_vTexcoord;
uniform float u_time;
uniform float u_intensity; // 液化强度 (0.0 ~ 1.0)
uniform float u_frequency; // 波纹频率
uniform float u_speed;     // 动画速度

void main()
{
    // 液化扰动：使用 sin/cos 模拟水波
    float wave1 = sin(v_vTexcoord.x * u_frequency + u_time * u_speed) * u_intensity * 0.02;
    float wave2 = cos(v_vTexcoord.y * u_frequency + u_time * u_speed + 1.3) * u_intensity * 0.02;
    
    // 可选：增加一点交叉扰动，让效果更自然
    float wave3 = sin((v_vTexcoord.x + v_vTexcoord.y) * u_frequency * 0.7 + u_time * u_speed * 0.9) * u_intensity * 0.015;

    vec2 offset = vec2(wave1 + wave3, wave2 + wave3);

    vec2 uv = v_vTexcoord + offset;

    // 采样镜像 surface
    gl_FragColor = texture2D(gm_BaseTexture, uv);
}