function Item_Init(){
	globalvar ITEM, ITEMEVENT;
	
	ITEMEVENT = {
		USE: "Use",
		CHECK: "Check",
		DROP: "Drop"
	}
	
	return { PlayerItemList:[], Custom: Item_Custom }
}