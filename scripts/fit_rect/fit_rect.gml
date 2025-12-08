/// @desc 计算在容器内居中显示内容的缩放后尺寸
/// @param content_w 内容宽度
/// @param content_h 内容高度
/// @param container_w 容器宽度
/// @param container_h 容器高度
/// @param fit_mode "cover" 或 "contain"
/// @returns [new_w, new_h]
function fit_rect(content_w, content_h, container_w, container_h, fit_mode = "contain") {
    var ratio = content_w / content_h;
    var container_ratio = container_w / container_h;
    var new_w, new_h;
    if (fit_mode == "cover") {
        if (container_ratio > ratio) {
            new_h = container_h;
            new_w = container_h * ratio;
        } else {
            new_w = container_w;
            new_h = container_w / ratio;
        }
    } else {
        if (container_ratio > ratio) {
            new_w = container_w;
            new_h = container_w / ratio;
        } else {
            new_h = container_h;
            new_w = container_h * ratio;
        }
    }
    return [new_w, new_h];
}