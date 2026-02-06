if (Battle_ReviseMenuFightDamage() > 0) {
    var X = GetCoordinates(160, 480, Battle_GetEnemyCount());
    instance_create_depth(X[Battle_ReviseChoiceMenu()], 160, 0, battle_menu_fight_knife);
}