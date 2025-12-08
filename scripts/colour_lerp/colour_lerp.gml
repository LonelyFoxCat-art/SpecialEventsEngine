/// @desc 颜色线性插值（混合）
/// @param c1 起始颜色
/// @param c2 结束颜色
/// @param t 插值因子 [0,1]
/// @returns 混合颜色
function colour_lerp(c1, c2, t) {
    var r1 = colour_get_red(c1);
    var g1 = colour_get_green(c1);
    var b1 = colour_get_blue(c1);

    var r2 = colour_get_red(c2);
    var g2 = colour_get_green(c2);
    var b2 = colour_get_blue(c2);

    var r = round(lerp(r1, r2, t));
    var g = round(lerp(g1, g2, t));
    var b = round(lerp(b1, b2, t));

    return make_colour_rgb(r, g, b);
}