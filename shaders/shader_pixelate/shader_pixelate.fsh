varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_targetBlockSize; // 目标像素块大小 (逻辑单位)
uniform vec2 u_viewportSize;     // 实际视口尺寸
uniform float u_gridIntensity;   // 网格强度 (0.0-1.0)
uniform float u_colorDepth;      // 色深 (1-8 bits)
uniform float u_debugMode;       // 调试模式

void main() {
    // ===== 智能计算对齐参数 =====
    vec2 blockCounts = floor(u_viewportSize / u_targetBlockSize);
    vec2 alignedViewSize = blockCounts * u_targetBlockSize;
    vec2 offset = (u_viewportSize - alignedViewSize) * 0.5;
    vec2 alignedCoord = v_vTexcoord * u_viewportSize - offset;
    
    if (alignedCoord.x < 0.0 || alignedCoord.y < 0.0 || 
        alignedCoord.x >= alignedViewSize.x || alignedCoord.y >= alignedViewSize.y) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    
    // ===== 精确像素化计算 =====
    vec2 blockPos = floor(alignedCoord / u_targetBlockSize) * u_targetBlockSize;
    vec2 samplePos = (blockPos + vec2(u_targetBlockSize * 0.5)) / alignedViewSize;
    vec4 color = texture2D(gm_BaseTexture, samplePos);
    
    // ===== 色深量化 =====
    if (u_colorDepth < 7.9) { // 7.9 避免8位时计算
        float levels = pow(2.0, u_colorDepth);
        color.rgb = floor(color.rgb * levels) / levels;
    }
    
    // ===== 智能网格线 =====
    vec2 pixelInBlock = mod(alignedCoord, u_targetBlockSize);
    float gridLine = 0.0;
    float border = 1.0;
    
    if (u_gridIntensity > 0.0) {
        if (pixelInBlock.x < border || pixelInBlock.y < border || pixelInBlock.x > u_targetBlockSize - border || pixelInBlock.y > u_targetBlockSize - border) {
            gridLine = u_gridIntensity * min(1.0, 8.0 / u_targetBlockSize);
        }
    }
    
    color.rgb = mix(color.rgb, vec3(0.15), gridLine * 0.8);
    
    // ===== 调试可视化 =====
    if (u_debugMode > 0.5) {
        if (alignedCoord.x < 2.0 || alignedCoord.y < 2.0 || alignedCoord.x > alignedViewSize.x - 2.0 || alignedCoord.y > alignedViewSize.y - 2.0) {
            color = vec4(0.0, 1.0, 1.0, 1.0);
        }
        
        vec2 centerDist = abs(pixelInBlock - vec2(u_targetBlockSize * 0.5));
        if (centerDist.x < 2.0 && centerDist.y < 2.0) {
            color = vec4(0.0, 1.0, 0.0, 1.0);
        }
    }
    
    gl_FragColor = color;
}