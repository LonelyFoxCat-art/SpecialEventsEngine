function Item_Remove(slot_index, count = 1){
	var list = StorageData.Invoke("Item").PlayerItemList;
	
	if (slot_index < 0 || slot_index >= array_length(list)) {
		return false;
	}
	
	var slot = list[slot_index];
	if (count == -1 || count >= slot.Count) {
		array_delete(list, slot_index, 1);
	} else {
		slot.Count -= count;
	}
	
	return true;
}