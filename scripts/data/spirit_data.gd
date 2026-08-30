class_name SpiritData
extends Resource

## 精灵种类静态数据。新增精灵 = 新增一个 .tres，不改代码。
## 字段含义见 docs/design.md 7.1 节。

@export var id: String
@export var display_name: String
@export var element := "草"                     # 草/水/火/土/风/光/暗...
@export_multiline var description := ""

@export var base_stats := {
	"max_energy": 100,
	"work_speed": 1.0,
	"harvest_bonus": 0.0,
}

## 偏好食物：crop_id -> 额外成长倍率（喂偏好食物心情加成更高）
@export var preferred_food: Dictionary = {}
## 擅长工作：water / hoe / plant / harvest / forage / ...
@export var skills: Array[String] = []
