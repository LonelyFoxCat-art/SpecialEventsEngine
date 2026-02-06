///@descr 播放声音(如果符号正确且不是跳过)
var char = string_char_at(text[index], number);
if (skipping || instant) {
    exit;
}
if (char == "{" || char == "&" || char == " " || char=="　") {
    exit;
}
var Length = array_length(group_sound[sound])
if (Length > 0) {
    var Sound = group_sound[sound][irandom(Length - 1)];
    if(audio_exists(Sound)){
        if (!is_undefined(current_sound)) {
            audio_stop_sound(current_sound);
        }
        audio_play_sound(Sound, 0, false);
        current_sound = Sound;
    }
}