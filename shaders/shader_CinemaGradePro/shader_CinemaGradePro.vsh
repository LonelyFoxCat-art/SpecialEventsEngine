// CinemaGradePro 顶点着色器 v1.4
// 与片段着色器配套使用，提供必要的几何处理

attribute vec3 in_Position;       // 顶点位置
attribute vec4 in_Colour;         // 顶点颜色
attribute vec2 in_TextureCoord;   // 纹理坐标

varying vec2 v_vTexcoord;         // 传递给片段着色器的纹理坐标
varying vec4 v_vColour;           // 传递给片段着色器的顶点颜色
varying vec2 v_vScreenPos;        // 传递给片段着色器的屏幕空间坐标[0,1]

void main() {
    // 传递纹理坐标
    v_vTexcoord = in_TextureCoord;
    
    // 传递顶点颜色
    v_vColour = in_Colour;
    
    // 计算屏幕空间坐标[0,1]
    vec4 worldPos = gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position, 1.0);
    vec4 clipPos = gm_Matrices[MATRIX_PROJECTION] * worldPos;
    v_vScreenPos = clipPos.xy / clipPos.w * 0.5 + 0.5; // 转换到[0,1]范围
    
    // 最终顶点位置
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
}