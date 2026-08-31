class_name WorldVisuals
extends Node2D

## 运行时生成的轻量视觉层：水面、树下阴影和少量像素级动态细节。
## 不使用外部贴图，避免新增素材和过滤设置破坏 Tiny 风格。

var _water_tiles: Array[Vector2i] = []
var _tree_shadow_positions: Array[Vector2] = []
var _phase := 0.0


func _process(delta: float) -> void:
	_phase = fmod(_phase + delta, 100.0)
	queue_redraw()


func set_water_tiles(tiles: Array[Vector2i]) -> void:
	_water_tiles = tiles.duplicate()
	queue_redraw()


func add_tree_shadow(tile: Vector2i) -> void:
	_tree_shadow_positions.append(Vector2(tile.x * 16 + 8, tile.y * 16 + 14))
	queue_redraw()


func _draw() -> void:
	_draw_water()
	_draw_tree_shadows()


func _draw_water() -> void:
	for tile in _water_tiles:
		var origin := Vector2(tile.x * 16, tile.y * 16)
		draw_rect(Rect2(origin, Vector2(16, 16)), Color(0.20, 0.52, 0.64, 1.0))
		draw_rect(Rect2(origin + Vector2(0, 0), Vector2(16, 2)), Color(0.29, 0.64, 0.72, 1.0))
		draw_rect(Rect2(origin + Vector2(0, 14), Vector2(16, 2)), Color(0.15, 0.40, 0.54, 1.0))

		var shimmer_x := fmod(_phase * 5.0 + float((tile.x + tile.y) * 4), 13.0)
		var shimmer := Color(0.54, 0.80, 0.82, 0.75)
		draw_line(origin + Vector2(shimmer_x, 6), origin + Vector2(minf(shimmer_x + 4.0, 15.0), 6), shimmer, 1.0)
		draw_line(origin + Vector2(fmod(shimmer_x + 7.0, 13.0), 10), origin + Vector2(fmod(shimmer_x + 10.0, 13.0), 10), shimmer, 1.0)


func _draw_tree_shadows() -> void:
	for center in _tree_shadow_positions:
		var points := PackedVector2Array()
		for i in range(16):
			var angle := TAU * float(i) / 16.0
			points.append(center + Vector2(cos(angle) * 8.0, sin(angle) * 2.5))
		draw_colored_polygon(points, Color(0.08, 0.07, 0.12, 0.34))
