function Item_GetNumber(){
	var list = StorageData.Invoke("Item").PlayerItemList;
	return array_length(list);
}