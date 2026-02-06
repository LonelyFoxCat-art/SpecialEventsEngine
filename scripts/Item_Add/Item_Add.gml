function Item_Add(Item, Count = 1) {
    if (!is_struct(Item) || Count <= 0) return 0;
    
    var list = StorageData.Invoke("Item").PlayerItemList;
    var MaxStack = Item.MaxStack ?? 64;
    var Remaining = Count;
    
    if (Item_IsStackable(Item)) {
        for (var i = 0; i < array_length(list); i++) {
            var existing = list[i];
            if (existing.Count < existing.MaxStack ?? MaxStack) {
                var space = (existing.MaxStack ?? MaxStack) - existing.Count;
                var add = min(space, Remaining);
                
                existing.Count += add;
                Remaining -= add;
                
                if (Remaining <= 0) break;
            }
        }
    }
    
    while (Remaining > 0) {
        var NewItem = struct_create(Item);
        NewItem.Count = min(Remaining, MaxStack);
        array_push(list, NewItem);
        Remaining -= NewItem.Count;
    }
    
    return Count - Remaining;
}
