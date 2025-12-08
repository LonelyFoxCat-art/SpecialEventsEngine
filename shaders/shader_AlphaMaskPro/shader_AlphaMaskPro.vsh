// AlphaMask Pro Vertex Shader v3.0
// 作者：狐猫雨空
// 优化顶点变换与属性传递

attribute vec3 in_Position;      // 顶点位置 (x,y,z)
attribute vec4 in_Colour;        // 顶点颜色 (r,g,b,a)
attribute vec2 in_TextureCoord;  // 纹理坐标 (u,v)

varying vec2 v_vTexcoord;        // 传递给片段着色器的纹理坐标
varying vec4 v_vColour;          // 传递给片段着色器的顶点颜色

// ======== 主函数 ========
void main() {
    // 顶点变换
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    
    // 传递基础数据
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}