class_name FarmMap
extends Node2D

## v0.1 农场地图：根据 ASCII 数据生成地面/细节两层 TileMap。
##
## 瓦片编号全部集中在这个文件里（Tiny Town / Tiny Farm 都是 12 列 x 11 行，
## 编号 = 行 * 12 + 列）。瓦片编号是根据颜色分析初选的，
## 如果某个图块显示不对，直接在 Godot 编辑器里打开素材图对照后改这里。

signal notice(message: String)

const TOWN_TEX := "res://assets/kenney/tiny-town/Tilemap/tilemap_packed.png"
const FARM_TEX := "res://assets/kenney/tiny-farm/Tilemap/tilemap_packed.png"

# --- 瓦片编号（Tiny Town） ---
const GRASS := [0]
const GRASS_DECOR := [1, 2]
const PATH_C := 25
const WATER := 61 # 仅用于占位和碰撞，实际水面由 WorldVisuals 绘制
const TREES := [4, 15, 16, 27, 28]
const BUSH := 17
const FLOWER := 29

# 耕地使用 Tiny Farm 的土壤瓦片；Town 图集没有水面地形。
const FARM_SOURCE_ID := 1
const SOIL := 49
const SOIL_VARIANTS := [0, 1, 36, 37]

const CROP_TEXTS := [
	"res://assets/sprites/crops/crop_stage_0.png",
	"res://assets/sprites/crops/crop_stage_1.png",
	"res://assets/sprites/crops/crop_stage_2.png",
	"res://assets/sprites/crops/crop_stage_3.png",
	"res://assets/sprites/crops/crop_stage_4.png",
]
const WATERED_TEX := "res://assets/sprites/fx/watered.png"
const CROP_MATURE_STAGE := 4

# 地图：T=树(边界) g=草地 p=小路 w=水 s=耕地 F=花 B=灌木
const MAP_TEXT := """
TTTTTTTTTTTTTTTTTTTTTTTTTTTT
TggggggggggggggggggggggggggT
TggggggggggggggggggggggggggT
TggppppppppppppppppppppppggT
TggpsssssssssssssssssssspggT
TggpsggggggggggggggggggspggT
TggpsggggggggggggggggggspggT
TggpsggggggggggggggggggspggT
TggpsggggggggggggggggggspggT
TggpsssssssssssssssssssspggT
TggppppppppppppppppppppppggT
TggggggwwwwwwwwwwwwggggggggT
TggggggwwwwwwwwwwwwggggggggT
TggggggwwwwwwwwwwwwggggggggT
TggggggggggggggggggggggggggT
TgggggFggggggggggggggggggggT
TgggggggggBggggggggggggggggT
TggggggggggggggggggggggggggT
TggggggggggggggggggggggggggT
TTTTTTTTTTTTTTTTTTTTTTTTTTTT
"""

# 地面状态：grass / path / water / soil / watered
var ground := {}
# 作物：Vector2i -> {"stage": int, "sprite": Sprite2D}
var crops := {}
var droplets := {}

var _ground_layer: TileMapLayer
var _visual_layer: WorldVisuals
var _detail_layer: TileMapLayer
var _water_tiles: Array[Vector2i] = []


func _ready() -> void:
	_ground_layer = TileMapLayer.new()
	_ground_layer.name = "Ground"
	add_child(_ground_layer)

	_visual_layer = WorldVisuals.new()
	_visual_layer.name = "WorldVisuals"
	add_child(_visual_layer)

	_detail_layer = TileMapLayer.new()
	_detail_layer.name = "Details"
	_detail_layer.y_sort_enabled = true
	add_child(_detail_layer)

	_ground_layer.tile_set = _build_ground_tileset()
	_detail_layer.tile_set = _build_detail_tileset()
	_build_map()
	_visual_layer.set_water_tiles(_water_tiles)

	GameState.day_changed.connect(_on_day_changed)


## 玩家脚底前方一格（facing 必须是归一化方向）
func front_tile(from_global: Vector2, facing: Vector2i) -> Vector2i:
	var foot := _ground_layer.local_to_map(to_local(from_global) + Vector2(0, 8))
	return foot + facing


func hoe(tile: Vector2i) -> void:
	match ground.get(tile, ""):
		"grass":
			_set_tile(tile, SOIL_VARIANTS[randi() % SOIL_VARIANTS.size()], "soil", FARM_SOURCE_ID)
			notice.emit("锄地完成，可以播种了")
		"soil", "watered":
			notice.emit("这里已经开垦过了")
		_:
			notice.emit("这里不能锄地")


func water(tile: Vector2i) -> void:
	if ground.get(tile, "") == "soil":
		ground[tile] = "watered"
		var sprite := Sprite2D.new()
		sprite.texture = load(WATERED_TEX)
		sprite.position = tile_center(tile)
		sprite.z_index = 1
		add_child(sprite)
		droplets[tile] = sprite
		notice.emit("浇水完成")
	elif ground.get(tile, "") == "watered":
		notice.emit("这块地已经浇过水了")
	else:
		notice.emit("这里不能浇水")


func plant(tile: Vector2i) -> void:
	if crops.has(tile):
		notice.emit("这里已经有作物了")
		return
	var state: String = ground.get(tile, "")
	if state != "soil" and state != "watered":
		notice.emit("请先锄地再播种")
		return
	var sprite := Sprite2D.new()
	sprite.texture = load(CROP_TEXTS[0])
	sprite.position = tile_center(tile) + Vector2(0, 6)
	sprite.z_index = 2
	add_child(sprite)
	crops[tile] = {"stage": 0, "sprite": sprite}
	notice.emit("播种完成，作物每天生长一阶段")


func harvest(tile: Vector2i) -> void:
	if not crops.has(tile):
		notice.emit("这里没有可收获的作物")
		return
	var crop: Dictionary = crops[tile]
	if crop["stage"] < CROP_MATURE_STAGE:
		notice.emit("作物还没成熟（%d/%d）" % [crop["stage"], CROP_MATURE_STAGE])
		return
	crop["sprite"].queue_free()
	crops.erase(tile)
	GameState.money += 10
	GameState.harvests += 1
	EventBus.crop_harvested.emit("demo_wheat", tile, 1)
	notice.emit("收获小麦 +10 金币")


func _on_day_changed(_day: int, _season: int) -> void:
	for tile in crops.keys():
		var crop: Dictionary = crops[tile]
		if crop["stage"] < CROP_MATURE_STAGE:
			crop["stage"] += 1
			crop["sprite"].texture = load(CROP_TEXTS[crop["stage"]])


func tile_center(tile: Vector2i) -> Vector2:
	return Vector2(tile.x * 16 + 8, tile.y * 16 + 8)


func _build_ground_tileset() -> TileSet:
	var ts := TileSet.new()
	ts.tile_size = Vector2i(16, 16)
	ts.add_physics_layer()
	ts.set_physics_layer_collision_layer(0, 1)
	ts.set_physics_layer_collision_mask(0, 1)
	var town_src := _add_atlas_source(ts, TOWN_TEX, 0)
	_add_atlas_source(ts, FARM_TEX, FARM_SOURCE_ID)
	_block_tile(town_src, WATER)
	return ts


func _build_detail_tileset() -> TileSet:
	var ts := TileSet.new()
	ts.tile_size = Vector2i(16, 16)
	ts.add_physics_layer()
	ts.set_physics_layer_collision_layer(0, 1)
	ts.set_physics_layer_collision_mask(0, 1)
	var src := _add_atlas_source(ts, TOWN_TEX, 0)
	for t in TREES:
		_block_tile(src, t)
	return ts


func _add_atlas_source(ts: TileSet, texture_path: String, source_id: int) -> TileSetAtlasSource:
	var src := TileSetAtlasSource.new()
	src.texture = load(texture_path)
	src.texture_region_size = Vector2i(16, 16)
	for i in range(132):
		src.create_tile(Vector2i(i % 12, i / 12))
	ts.add_source(src, source_id)
	return src


func _block_tile(src: TileSetAtlasSource, idx: int) -> void:
	var td := src.get_tile_data(Vector2i(idx % 12, idx / 12), 0)
	td.add_collision_polygon(0)
	td.set_collision_polygon_points(0, 0, PackedVector2Array([
		Vector2(0, 0), Vector2(16, 0), Vector2(16, 16), Vector2(0, 16),
	]))


func _build_map() -> void:
	var lines := MAP_TEXT.strip_edges().split("\n")
	for y in lines.size():
		var line := lines[y].strip_edges()
		for x in line.length():
			var tile := Vector2i(x, y)
			match line[x]:
				"T":
					_set_grass(tile)
					_set_detail(tile, TREES[y % TREES.size()])
					_visual_layer.add_tree_shadow(tile)
				"g":
					_set_grass(tile)
				"p":
					_set_tile(tile, PATH_C, "path")
				"w":
					_set_tile(tile, WATER, "water")
					_water_tiles.append(tile)
				"s":
					_set_tile(tile, SOIL, "soil", FARM_SOURCE_ID)
				"F":
					_set_grass(tile)
					_set_detail(tile, FLOWER)
				"B":
					_set_grass(tile)
					_set_detail(tile, BUSH)


func _set_grass(tile: Vector2i) -> void:
	_set_tile(tile, GRASS[0], "grass")
	if randf() < 0.12:
		_set_detail(tile, GRASS_DECOR[randi() % GRASS_DECOR.size()])


func _set_detail(tile: Vector2i, idx: int) -> void:
	_detail_layer.set_cell(tile, 0, Vector2i(idx % 12, idx / 12))


func _set_tile(tile: Vector2i, idx: int, state: String, source_id: int = 0) -> void:
	_ground_layer.set_cell(tile, source_id, Vector2i(idx % 12, idx / 12))
	ground[tile] = state
