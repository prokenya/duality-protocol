class_name GridMovementBody
extends CharacterBody2D

@export_range(5, 200, 5) var speed = 150

@export var direction_ray: RayCast2D
@export var cell_size: int = 32
@export var bias: int = 16

@onready var next_tile_cords: Vector2 = round(position / bias) * bias

@onready var tween: Tween


func _ready() -> void:
	direction_ray.target_position = Vector2(0, cell_size)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down").sign()

	if Vector2i(position) != Vector2i(next_tile_cords):
		move_character()
		return

	if direction == Vector2.ZERO:
		return

	var target_position = position + direction * cell_size

	if not is_blocked(direction):
		if not is_blocked(Vector2(direction.x, 0)) and not is_blocked(Vector2(0, direction.y)):
			next_tile_cords = target_position
		else:
			if not is_blocked(Vector2(direction.x, 0)):
				next_tile_cords.x = target_position.x
			elif not is_blocked(Vector2(0, direction.y)):
				next_tile_cords.y = target_position.y
	else:
		if not is_blocked(Vector2(direction.x, 0)):
			next_tile_cords.x = target_position.x
		elif not is_blocked(Vector2(0, direction.y)):
			next_tile_cords.y = target_position.y

	

func is_blocked(dir: Vector2) -> bool:
	direction_ray.rotation = dir.angle() - PI / 2
	direction_ray.force_raycast_update()
	return direction_ray.is_colliding()


func move_character():
	if tween:
		if tween.is_running(): 
			return
		tween.kill()
	tween = create_tween()

	var dist = position.distance_to(next_tile_cords)
	var duration = dist / speed

	tween.tween_property(self, "position", next_tile_cords, duration)

		
