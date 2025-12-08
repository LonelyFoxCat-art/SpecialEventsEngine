/// @description使用可选的内部缩放绘制带边框的矩形
/// @param {real} x 左上x坐标
/// @param {real} y 左上角y坐标
/// @param {real} width 矩形的总宽度
/// @param {real} height 矩形的总高度
/// @param {color} border_color 边框颜色
/// @param {color} fill_color 内部填充的颜色
/// @param {array} [scale] 可选数组[left，top，right，bottom]指定内部偏移量
function draw_board(x, y, width, height, border_color, fill_color, scale = [5,5,5,5]) {
    if (array_length(scale) < 4) {
        scale = [0,0,0,0];
    }
    
    var right = x + width;
    var bottom = y + height;
    
    draw_rectangle_color(x, y, right, bottom, border_color, border_color, border_color, border_color, false);
    
    if (width > (scale[0] + scale[2]) && height > (scale[1] + scale[3])) {
        var fill_x1 = x + scale[0];
        var fill_y1 = y + scale[1];
        var fill_x2 = right - scale[2];
        var fill_y2 = bottom - scale[3];
        
        draw_rectangle_color(fill_x1, fill_y1, fill_x2, fill_y2, fill_color, fill_color, fill_color, fill_color, false);
    }
}