@tool
extends AnimatableBody2D

@export var direction: Vector2 = Vector2(0, 0):
	set(value):
		direction = value
		ray.target_position = direction * 17
		sprite.rotation = direction.angle() + PI
@export var ray: RayCast2D

@export var sprite:Sprite2D

var anim_block: bool = false
var speed = 3


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _physics_process(delta: float) -> void:
	if !anim_block: return
	ray.force_raycast_update()
	if ray.is_colliding():
		anim_block = false
		return
	position += direction * speed


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_BUSY)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lmb"):
		anim_block = true
