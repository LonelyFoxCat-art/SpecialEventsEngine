// 3D基础片元着色器 v1.0
// 作者：狐猫雨空

varying vec4 v_vColour;
varying vec4 v_vPosition;
varying vec2 v_vTexture;

void main() {
    // 采样纹理 (gm_BaseTexture 是 GameMaker 的默认纹理)
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexture);
    
    // 应用顶点颜色
    gl_FragColor = v_vColour * texColor;
}