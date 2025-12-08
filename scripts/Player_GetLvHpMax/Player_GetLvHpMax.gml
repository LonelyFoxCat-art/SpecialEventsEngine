function Player_GetLvHpMax(Lv, BaseHp = 20, HpPerLv = 4, SoftCapLv = 20, HardCap = 99) {
    if (Lv >= SoftCapLv) {
        return HardCap;
    } else {
        return BaseHp + (Lv - 1) * HpPerLv;
    }
}