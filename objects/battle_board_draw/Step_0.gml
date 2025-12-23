global.BoardList = InstanceGetList(battle_board)
array_sort(global.BoardList, function(a, b) {
if (a.depth == b.depth) return a.Index > b.Index;
	return a.depth < b.depth;
})