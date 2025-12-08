function Player_GetLvExp(Lv, BaseExp = 10, GrowthRate = 1.5, MaxLv = 20, MaxExp = 99999) {
    if (Lv < 2) return 10;
    if (Lv >= MaxLv) return MaxExp;
    
    if (Lv <= 5) {
        return BaseExp * (Lv - 1) + (Lv - 1) * (Lv - 2) * 5;
    }
    else if (Lv <= 10) {
        var _x = Lv - 5;
        return 120 + _x * 80 + _x * _x * 10;
    }
    else if (Lv <= 15) {
        var _x = Lv - 10;
        return 1200 + power(_x, GrowthRate) * 500;
    }
    else {
        var _x = Lv - 15;
        return 7000 + _x * 3000 + _x * _x * 2000;
    }
}