// 创建一个新的脚本文件 script_focus_manager
function CGlobalFocus() constructor {
    // 静态变量存储所有可聚焦控件
    static focusable_items = [];
    static currently_focused = undefined;
    
    // 注册可聚焦控件
    register = function(item) {
        if (!array_contains(focusable_items, item)) {
            array_push(focusable_items, item);
        }
    };
    
    // 取消注册
    unregister = function(item) {
        array_delete(focusable_items, array_indexofall(focusable_items, item), 1);
    };
    
    // 设置当前焦点
    set_focus = function(item) {
        // 先取消之前聚焦的项
        if (is_struct(currently_focused) && currently_focused != item) {
            currently_focused.set_focus(false);
        }
        
        currently_focused = item;
        
        if (is_struct(item)) {
            item.set_focus(true);
        }
    };
    
    // 获取当前焦点项
    get_focused = function() {
        return currently_focused;
    };
    
    // 清除所有焦点
    clear_focus = function() {
        if (is_struct(currently_focused)) {
            currently_focused.set_focus(false);
        }
        currently_focused = undefined;
    };
}