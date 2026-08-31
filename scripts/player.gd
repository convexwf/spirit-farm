extends CharacterBody2D

const SPEED := 90.0
const FARM_TEX := "res://assets/kenney/tiny-farm/Tilemap/tilemap_packed.png"
const PLAYER_FRONT_TILE := 108
const PLAYER_SIDE_TILE := 109

var facing := Vector2i.DOWN
var _walk_phase := 0.0
var _sprite_base_position := Vector2.ZERO
var _front_texture: AtlasTexture
var _side_texture: AtlasTexture

@onready var sprite: Sprite2D = $Sprite2D
@onready var farm_map: FarmMap = get_node("../FarmMap")

# 输入动作在运行时注册，避免手写 project.godot 的输入序列化格式。
const ACTIONS := {
	"move_left": [KEY_A, KEY_LEFT],
	"move_right": [KEY_D, KEY_RIGHT],
	"move_up": [KEY_W, KEY_UP],
	"move_down": [KEY_S, KEY_DOWN],
	"hoe": [KEY_SPACE],
	"plant": [KEY_E],
	"harvest": [KEY_X],
}


func _ready() -> void:
	_sprite_base_position = sprite.position
	_front_texture = _atlas_tile_texture(PLAYER_FRONT_TILE)
	_side_texture = _atlas_tile_texture(PLAYER_SIDE_TILE)
	_update_direction_texture()
	for action: String in ACTIONS:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in ACTIONS[action]:
			var ev := InputEventKey.new()
			ev.physical_keycode = key
			InputMap.action_add_event(action, ev)


func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * SPEED
	move_and_slide()
	if dir != Vector2.ZERO:
		_walk_phase += _delta * 10.0
		sprite.position = _sprite_base_position + Vector2(0, -absf(sin(_walk_phase)))
		if absf(dir.x) >= absf(dir.y):
			facing = Vector2i(signi(dir.x), 0)
		else:
			facing = Vector2i(0, signi(dir.y))
		_update_direction_texture()
	else:
		_walk_phase = 0.0
		sprite.position = _sprite_base_position


func _update_direction_texture() -> void:
	if facing.x != 0:
		sprite.texture = _side_texture
		sprite.flip_h = facing.x < 0
	else:
		# Tiny Farm 当前只提供正面/侧面农夫图；向上先复用正面图，
		# 保留独立入口，后续补正式背面帧时不需要改移动逻辑。
		sprite.texture = _front_texture
		sprite.flip_h = false


func _atlas_tile_texture(idx: int) -> AtlasTexture:
	var texture := AtlasTexture.new()
	texture.atlas = load(FARM_TEX)
	texture.region = Rect2((idx % 12) * 16, (idx / 12) * 16, 16, 16)
	return texture


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hoe"):
		farm_map.hoe(farm_map.front_tile(global_position, facing))
	elif event.is_action_pressed("plant"):
		farm_map.plant(farm_map.front_tile(global_position, facing))
	elif event.is_action_pressed("harvest"):
		farm_map.harvest(farm_map.front_tile(global_position, facing))
