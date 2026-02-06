function Item_IsStackable(Item){
	if (!is_struct(Item)) return false;
    if (struct_exists(Item, "MaxStack")) return Item.MaxStack > 1;
}