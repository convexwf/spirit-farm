extends CharacterBody2D

const SPEED := 90.0

var facing := Vector2i.DOWN

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
		if absf(dir.x) >= absf(dir.y):
			facing = Vector2i(signi(dir.x), 0)
		else:
			facing = Vector2i(0, signi(dir.y))
		sprite.flip_h = facing.x < 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hoe"):
		farm_map.hoe(farm_map.front_tile(global_position, facing))
	elif event.is_action_pressed("plant"):
		farm_map.plant(farm_map.front_tile(global_position, facing))
	elif event.is_action_pressed("harvest"):
		farm_map.harvest(farm_map.front_tile(global_position, facing))
