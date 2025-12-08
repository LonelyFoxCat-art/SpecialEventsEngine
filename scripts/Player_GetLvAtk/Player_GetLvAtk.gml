function Player_GetLvAtk(Lv, BaseAtk = 10, AtkPerLv = 2, MaxAtk = undefined) {
    var result = BaseAtk + (Lv - 1) * AtkPerLv;
    return MaxAtk ? min(result, MaxAtk) : result;
}