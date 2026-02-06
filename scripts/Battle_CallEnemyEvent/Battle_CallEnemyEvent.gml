function Battle_CallEnemyEvent(event, index = -1) {
    if (!instance_exists(battle)) return false;
    
    if (index == -1) {
        for (var i = 0; i < Battle_GetEnemyCount(); i++) {
            var inst = Battle_ReviseEnemy(i);
            if (instance_exists(inst)) {
                with (inst) event_user(event);
            }
        }
        return true;
    }
    
    if (index >= 0 && index < Battle_GetEnemyCount()) {
        var inst = Battle_ReviseEnemy(index);
        if (instance_exists(inst)) {
            with (inst) event_user(event);
        }
        return true;
    }
    
    return false;
}