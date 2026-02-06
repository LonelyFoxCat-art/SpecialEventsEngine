function Item_GetTotalCount(Item){
	var list = StorageData.Invoke("Item").PlayerItemList;
	var total = 0;
	for (var i = 0; i < array_length(list); i++) {
		var slot = list[i];
		if (slot.Id == Item.Id) {
			total += slot.Count;
		}
	}
	
	return total;
}