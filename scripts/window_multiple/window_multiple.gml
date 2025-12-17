/// @function                  window_get_multiple(DesignWidth, DesignHeight, [OffsetX], [OffsetY])
/// @description               计算窗口/全屏模式下的自适应缩放参数，保持原始宽高比
/// @param      {real}         DesignWidth   - 设计分辨率宽度
/// @param      {real}         DesignHeight  - 设计分辨率高度
/// @param      {real}         [OffsetX]     - 设计坐标系X偏移（默认0）
/// @param      {real}         [OffsetY]     - 设计坐标系Y偏移（默认0）
/// @returns    {self}						 - 包含缩放倍数和偏移量的结构体

function window_get_multiple(DesignWidth, DesignHeight, OffsetX = 0, OffsetY = 0) {
    // 参数验证
    DesignWidth  = max(1, abs(real(DesignWidth)));
    DesignHeight = max(1, abs(real(DesignHeight)));
    OffsetX      = real(OffsetX);
    OffsetY      = real(OffsetY);

    // 获取当前显示尺寸
    var ScreenWidth  = window_get_fullscreen() ? display_get_width()  : window_get_width();
    var ScreenHeight = window_get_fullscreen() ? display_get_height() : window_get_height();

    // 计算等比例缩放因子
    var ScaleX = ScreenWidth  / DesignWidth;
    var ScaleY = ScreenHeight / DesignHeight;
    var ScaleFactor = min(ScaleX, ScaleY);

    // 计算居中偏移（考虑原始偏移量的缩放）
    var DisplayOffsetX = (ScreenWidth  - DesignWidth  * ScaleFactor) / 2 + OffsetX * ScaleFactor;
    var DisplayOffsetY = (ScreenHeight - DesignHeight * ScaleFactor) / 2 + OffsetY * ScaleFactor;

    return {
        multiple  : ScaleFactor,   // 缩放倍数
        offset_x  : DisplayOffsetX, // 绘制X偏移
        offset_y  : DisplayOffsetY, // 绘制Y偏移
        real_width: DesignWidth * ScaleFactor,  // 实际渲染宽度
        real_height: DesignHeight * ScaleFactor  // 实际渲染高度
    };
}