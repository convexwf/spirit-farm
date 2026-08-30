class_name CropData
extends Resource

## 作物静态数据。新增作物 = 新增一个 .tres，不改代码。
## 字段含义见 docs/design.md 7.1 节。

@export var id: String
@export var display_name: String
@export var season: Array[String] = ["春"]      # 可种植季节
@export var growth_stages := 4                  # 生长阶段数（含成熟）
@export var days_per_stage := 1
@export var sell_price := 10
@export var seed_item_id := ""

## 结灵：0 表示不会结灵；>0 为收获时的基础概率（百分比）
@export var spirit_birth_chance := 0.0
## 可以孕育的精灵种类；结灵时按列表抽取（将来支持权重）
@export var spirit_species: Array[String] = []

## 喂养成长属性，例如：{ "xp": 5, "mood": 2, "work_speed": 0.01 }
@export var feed_effect: Dictionary = {}
## 是否为精灵进化素材
@export var evolution_material := false
