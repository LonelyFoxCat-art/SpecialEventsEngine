function Item_Has(Item, MinCount = 1) {
	return Item_GetTotalCount(Item) >= MinCount;
}