extends Node2D

## 主场景占位：后续从这里挂 TileMap、玩家、精灵与 UI。

func _ready() -> void:
	print("Spirit Farm 启动：第 %d 天，%s季" % [GameState.day, GameState.season_name])
	EventBus.crop_harvested.connect(_on_crop_harvested)

func _on_crop_harvested(crop_id: String, tile: Vector2i, quality: int) -> void:
	# 未来在这里接入"结灵"判定：品质和照料度决定孕育概率。
	print("收获 %s @ %s（品质 %d）" % [crop_id, tile, quality])
