varying vec2 v_vTexcoord;
uniform float u_time;
uniform float u_strength;   // 扭曲强度 (0.0 ~ 1.0)
uniform float u_speed;      // 动画速度

void main()
{
    // 基于时间和坐标生成动态偏移
    vec2 offset = vec2(
        sin(v_vTexcoord.y * 10.0 + u_time * u_speed) * u_strength * 0.02,
        cos(v_vTexcoord.x * 10.0 + u_time * u_speed) * u_strength * 0.02
    );

    // 应用偏移到纹理坐标
    vec2 uv = v_vTexcoord + offset;

    // 采样纹理（GameMaker 会自动绑定 surface 纹理到 gm_BaseTexture）
    gl_FragColor = texture2D(gm_BaseTexture, uv);
}