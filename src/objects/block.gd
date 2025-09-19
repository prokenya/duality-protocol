@tool
extends AnimatableBody2D

@export var direction: Vector2 = Vector2(0, 0):
	set(value):
		direction = value
		ray.target_position = direction * 17
		sprite.rotation = direction.angle() + PI
@export var ray: RayCast2D

@export var sprite:Sprite2D
@onready var start: AudioStreamPlayer = $start
@onready var end: AudioStreamPlayer = $end

var anim_block: bool = false:
	set(val):
		anim_block = val
		if val:
			start.play()
		else:
			end.play()
var speed = 3
var clicked:bool = false
var in_bridge:bool = false
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _physics_process(delta: float) -> void:
	if !anim_block: return
	ray.force_raycast_update()
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider is TileMapLayer:
			rm_tile(collider)
		anim_block = false
		direction = direction.rotated(PI / 2)
		return
	position += direction * speed


func rm_tile(collider: TileMapLayer):
	var cell_pos = collider.local_to_map(ray.global_position + direction * 32)
	var data = collider.get_cell_tile_data(cell_pos)
	var broken_bridge = data.get_custom_data("broken_bridge") as bool
	if broken_bridge:
		collider.set_cell(cell_pos, 0, Vector2i(3, 2))
		G.main.MainProgram.notify("1/3 of the bridge has been repaired")
		queue_free()


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_BUSY)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lmb"):
		anim_block = true
		if not clicked:
			G.main.MainProgram.notify("the player has already interacted with the magnetic block")
		clicked = true
