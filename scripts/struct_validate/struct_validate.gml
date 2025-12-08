/// @func struct_validate(struct, schema)
/// @desc 根据 schema 验证 struct 是否符合预期结构
/// @param {struct} _struct - 待验证结构
/// @param {struct} _schema - 模板结构，键值为期望类型（如 "string", "number", "struct"）
/// @returns {bool} 是否通过验证
function struct_validate(_struct, _schema) {
    if (!is_struct(_struct) || !is_struct(_schema)) return false;
    
    var _keys = struct_get_names(_schema);
    for (var _i = 0; _i < array_length(_keys); _i++) {
        var _key = _keys[_i];
        var _expected_type = _schema[@ _key];
        if (!struct_exists(_struct, _key)) return false;
        
        var _actual_val = _struct[@ _key];
        var _actual_type = typeof(_actual_val);
        
        switch (_expected_type) {
            case "string":
                if (_actual_type != "string") return false;
                break;
            case "number":
                if (_actual_type != "real" && _actual_type != "int64") return false;
                break;
            case "struct":
                if (!is_struct(_actual_val)) return false;
                break;
            case "array":
                if (!is_array(_actual_val)) return false;
                break;
            default:
                if (is_struct(_expected_type)) {
                    if (!is_struct(_actual_val)) return false;
                    if (!struct_validate(_actual_val, _expected_type)) return false;
                }
                break;
        }
    }
    return true;
}