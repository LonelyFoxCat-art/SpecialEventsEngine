if image_angle >= 360 image_angle = 0
image_xscale = width / 2

image_blend = (mode == 0 ? c_lime : make_color_rgb(255,0,255))

// 边界检测和移动逻辑
var IsInsideBoard  = Battle_IsBoardTouchTheEdge(1); // 增加检测范围

// X轴移动处理
if (bounce_x) {
    // 碰到左边界且向左移动，或碰到右边界且向右移动时反弹
    if ((!IsInsideBoard[2] && move_x > 0) || (!IsInsideBoard[3] && move_x < 0)) {
        move_x = -move_x; // 反转X方向
    }
    x += move_x;
}
 
// Y轴移动处理
y += move_y;