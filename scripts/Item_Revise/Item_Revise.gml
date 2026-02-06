function Item_Revise(Index, Item = undefined, Count = 1){
	var list = StorageData.Invoke("Item").PlayerItemList;
	if (is_undefined(Item)) return list[Index];
	
	list[Index] = struct_create(Item);
	list[Index].Count = Count;
	return true;
}