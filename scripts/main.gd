extends Node2D

## 主场景：时间流逝 + HUD 刷新。

const TICK_SECONDS := 0.1
const MINUTES_PER_TICK := 1

var _accum := 0.0
var _msg_timer := 0.0

@onready var farm_map: FarmMap = $World/FarmMap
@onready var info_label: Label = $HUD/InfoLabel
@onready var hint_label: Label = $HUD/HintLabel
@onready var msg_label: Label = $HUD/MsgLabel


func _ready() -> void:
	farm_map.notice.connect(_show_notice)
	GameState.day_changed.connect(func(_day: int, _season: int) -> void: _refresh_hud())
	hint_label.text = "WASD/方向键 移动    SPACE 锄地/浇水    E 播种    X 收获"
	_refresh_hud()
	if OS.get_cmdline_user_args().has("--selftest"):
		_selftest()


func _process(delta: float) -> void:
	_accum += delta
	while _accum >= TICK_SECONDS:
		_accum -= TICK_SECONDS
		GameState.advance_minutes(MINUTES_PER_TICK)
		_refresh_hud()
	if _msg_timer > 0.0:
		_msg_timer -= delta
		if _msg_timer <= 0.0:
			msg_label.text = ""


func _show_notice(text: String) -> void:
	msg_label.text = text
	_msg_timer = 2.0


func _refresh_hud() -> void:
	var hour := GameState.minute_of_day / 60
	var minute := GameState.minute_of_day % 60
	info_label.text = "第 %d 天  %s季  %02d:%02d    金币 %d    收获 %d" % [
		GameState.day,
		GameState.season_name,
		hour,
		minute,
		GameState.money,
		GameState.harvests,
	]


## 无头自检：-- --selftest 时验证核心玩法链路后退出。
func _selftest() -> void:
	var fm := farm_map
	var grass_tile := Vector2i(-1, -1)
	for tile in fm.ground:
		if fm.ground[tile] == "grass":
			grass_tile = tile
			break
	assert(grass_tile != Vector2i(-1, -1), "找不到草地格子")

	fm.hoe(grass_tile)
	assert(fm.ground[grass_tile] == "soil", "锄地失败")
	fm.water(grass_tile)
	assert(fm.ground[grass_tile] == "watered", "浇水失败")
	fm.plant(grass_tile)
	assert(fm.crops.has(grass_tile), "播种失败")
	for _i in range(4):
		fm._on_day_changed(GameState.day + 1, GameState.season)
	fm.harvest(grass_tile)
	assert(not fm.crops.has(grass_tile), "收获失败")
	assert(GameState.harvests == 1 and GameState.money == 10, "收获结算失败")
	print("SELFTEST OK: 锄地/浇水/播种/生长/收获 全部通过")
	get_tree().quit()
