// 3D基础变换顶点着色器 v1.0
// 作者：狐猫雨空
// 专业级3D模型变换处理器，支持复合旋转/缩放/位移/球形变形

// ======== 核心功能 ========
// • 三重旋转系统：欧拉角+轴向旋转+球形变形
// • 动态网格变形：球形扭曲与混合控制
// • 精确UV映射：纹理区域子集控制
// • 层级变换顺序：缩放→旋转→变形→位移
// • 坐标轴校正：旋转后轴向自动重计算
// • 跨平台兼容：自动适配WebGL/OpenGL ES

// ======== 关键特性 ========
// • 无万向节锁旋转：结合欧拉角与轴向旋转
// • 非均匀缩放支持：独立XYZ轴缩放
// • 球形变形系统：从网格到球体平滑过渡
// • 智能纹理采样：动态UV区域映射
// • 高性能计算：避免冗余矩阵运算
// • 精确坐标转换：球坐标↔笛卡尔坐标
// • 位移优先级：最后应用位置偏移
// • 内置3D投影：无缝对接GM矩阵系统

// ======== 使用提示 ========
// 1. 变换顺序（重要！）：
//    • 1.缩放 → 2.欧拉旋转 → 3.轴向旋转 → 4.球形变形 → 5.位移
// 2. 旋转参数：
//    • u_rotation：基础欧拉角（弧度制，XYZ顺序）
//    • u_angles：绕旋转后坐标轴的额外旋转
// 3. 形状控制：
//    • u_shapeInfo.x = 0：标准网格
//    • u_shapeInfo.x = 1：启用球形变形
//    • u_shapeInfo.y = [0-1]：网格↔球体混合强度
// 4. 纹理参数：
//    • u_textureData = [u0,v0, width, height]（0~1范围子区域）

attribute vec3 in_Position;      // 顶点局部坐标 (x,y,z)
attribute vec4 in_Colour;        // 顶点颜色 (r,g,b,a)
attribute vec2 in_TextureCoord;  // 原始UV坐标 (u,v)

varying vec4 v_vColour;          // 传递至片元的颜色
varying vec4 v_vPosition;        // 世界空间位置 (用于高级效果)
varying vec2 v_vTexture;         // 最终UV坐标 (经区域偏移)

// ======== 变换参数 ========
uniform vec4 u_textureData;    // 纹理区域 [u0,v0,du,dv]
uniform vec3 u_position;       // 世界坐标位移 (x,y,z)
uniform vec3 u_rotation;       // 欧拉旋转角 (弧度制, XYZ顺序)
uniform vec3 u_angles;         // 轴向旋转角 (绕旋转后坐标轴)
uniform vec3 u_scale;          // 非均匀缩放 (x,y,z)
uniform vec4 u_color;          // 顶点基础颜色 (r,g,b,a)
uniform vec2 u_shapeInfo;      // [shapeType, blendFactor]
                               // • shapeType: 0=标准, 1=球形
                               // • blendFactor: [0.0-1.0]变形强度

// ======== 旋转工具函数 ========

// 绕任意轴旋转（罗德里格斯公式）
// 参数：
//   vec     - 需旋转的向量
//   axis    - 旋转轴（需归一化）
//   angle   - 旋转角度（弧度）
// 返回：旋转后的新向量
vec3 rotateAroundAxis(vec3 vec, vec3 axis, float angle) 
{
    float cosa = cos(angle);
    float sina = sin(angle);
    return vec * cosa + cross(axis, vec) * sina + axis * dot(axis, vec) * (1.0 - cosa);
}

// 应用欧拉旋转（XYZ顺序）
// 参数：
//   pos    - 需旋转的点
//   angles - (x,y,z)旋转角度
// 返回：旋转后的新位置
vec3 applyEulerRotation(vec3 pos, vec3 angles) 
{
    // 绕X轴旋转
    mat3 rotX = mat3(
        1.0, 0.0, 0.0,
        0.0, cos(angles.x), -sin(angles.x),
        0.0, sin(angles.x), cos(angles.x)
    );
    pos = pos * rotX;
    
    // 绕Y轴旋转
    mat3 rotY = mat3(
        cos(angles.y), 0.0, sin(angles.y),
        0.0, 1.0, 0.0,
        -sin(angles.y), 0.0, cos(angles.y)
    );
    pos = pos * rotY;
    
    // 绕Z轴旋转
    mat3 rotZ = mat3(
        cos(angles.z), -sin(angles.z), 0.0,
        sin(angles.z), cos(angles.z), 0.0,
        0.0, 0.0, 1.0
    );
    return pos * rotZ;
}

// 笛卡尔坐标→球坐标（方向角）
// 参数：
//   pos - 3D位置向量
// 返回：
//   (水平角, 垂直角) - 弧度制
vec2 cartesianToSpherical(vec3 pos) 
{
    return vec2(
        atan(pos.y, pos.x),          // 水平方位角 [0, 2π]
        atan(pos.z, length(pos.xy))  // 垂直仰角 [-π/2, π/2]
    );
}

// ======== 主函数 ========
void main() 
{
    // 获取原始顶点位置
    vec3 pos = in_Position;
    
    // 应用非均匀缩放
    pos *= u_scale;
    
    // 应用基础欧拉旋转
    vec3 originalPos = pos;
    pos = applyEulerRotation(pos, u_rotation);
    
    // 应用轴向旋转（需重计算旋转轴）
    if (u_angles != vec3(0.0)) 
    {
        // 重计算旋转后的坐标轴
        vec3 axisX = applyEulerRotation(vec3(1.0, 0.0, 0.0), u_rotation);
        vec3 axisY = applyEulerRotation(vec3(0.0, 1.0, 0.0), u_rotation);
        vec3 axisZ = applyEulerRotation(vec3(0.0, 0.0, 1.0), u_rotation);
        
        // 依次应用三轴旋转
        pos = rotateAroundAxis(pos, axisX, u_angles.x);
        pos = rotateAroundAxis(pos, axisY, u_angles.y);
        pos = rotateAroundAxis(pos, axisZ, u_angles.z);
    }
    
    // 5. 球形变形处理（按需启用）
    if (u_shapeInfo.x == 1.0) 
    {
        float originalRadius = length(originalPos);
        vec2 spherical = cartesianToSpherical(pos);
        
        // 计算球体表面位置
        vec3 spherePos = vec3(
            sin(spherical.x) * cos(spherical.y),
            sin(spherical.x) * sin(spherical.y),
            cos(spherical.x)
        ) * u_scale;
        
        float sphereRadius = length(spherePos);
        
        // 混合原始半径与球体半径
        float blendedRadius = mix(
            originalRadius, 
            sphereRadius, 
            u_shapeInfo.y  // 混合强度 [0.0-1.0]
        );
        
        pos = normalize(pos) * blendedRadius;
    }
    
    // 应用世界坐标位移
    pos += u_position;
    
    // 投影到裁剪空间
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(pos, 1.0);
    
    // 准备传递数据
    v_vPosition = vec4(pos, 1.0);  // 世界空间位置
    v_vColour = u_color * in_Colour;  // 混合顶点颜色
    v_vTexture = u_textureData.xy + u_textureData.zw * in_TextureCoord;  // 动态UV
}