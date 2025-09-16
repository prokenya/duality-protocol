class_name GridMovementBody
extends CharacterBody2D

@export_range(5, 200, 5) var speed = 150

@export var direction_ray: RayCast2D
@export var cell_size: int = 32
@export var bias: int = 16

@onready var next_tile_cords: Vector2 = round(position / bias) * bias
var direction:Vector2
var direction_of_view:Vector2
var input_queue:Vector2 = Vector2.ZERO

@onready var tween: Tween


func _ready() -> void:
	direction_ray.target_position = Vector2(0, cell_size)


func _physics_process(delta: float) -> void:

	if Vector2i(position) != Vector2i(next_tile_cords):
		move_character()
		
		if direction != Vector2.ZERO:
			if direction_of_view != direction:
				input_queue = direction
		return
	if input_queue != Vector2.ZERO:
		direction = input_queue
		input_queue = Vector2.ZERO
	if direction == Vector2.ZERO:
		return
	
	direction_of_view = direction
	
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
	direction_ray.target_position = dir * cell_size
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

		
