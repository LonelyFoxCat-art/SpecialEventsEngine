function Item_InvokeEvent(Index, Event){
	var List = StorageData.Invoke("Item").PlayerItemList;
	if (Item_GetNumber() <= 0) return false;
	
	if (struct_exists(List[Index], "Fn")) {
		var Fn = List[Index].Fn;
		if (struct_exists(Fn, Event)) Fn[$ Event]();
		return true;
	}
	return false;
}