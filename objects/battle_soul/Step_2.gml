var AllBoard = InstanceGetList(battle_board);	// 获取所有框

// 初始化边界检查
var BoundaryChecks = [
	{ offsetX: 0, offsetY: sprite_height / 2, adjustX: 0, adjustY: -sprite_height / 2 },  // Bottom edge
	{ offsetX: 0, offsetY: -sprite_height / 2, adjustX: 0, adjustY: sprite_height / 2 },  // Top edge
	{ offsetX: sprite_width / 2, offsetY: 0, adjustX: -sprite_width / 2, adjustY: 0 },    // Right edge
	{ offsetX: -sprite_width / 2, offsetY: 0, adjustX: sprite_width / 2, adjustY: 0 }     // Left edge
];

// 对照所有框检查每个边界点
for (var i = 0; i < array_length(BoundaryChecks); i++) {
	
}