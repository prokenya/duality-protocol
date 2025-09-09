extends CharacterBody2D

@export var direction_ray:RayCast2D
@export var cell_size:int = 32
@export var bias:int = 16
@onready var next_tile_cords:Vector2 = round(position / bias) * bias
const SPEED = 20
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	direction_ray.target_position = Vector2(0,cell_size)
	
func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("left", "right","up","down").sign()
	
	if Vector2i(position) != Vector2i(next_tile_cords):
		position = next_tile_cords
		
	elif direction:
		direction_ray.rotation = direction.angle() - PI/2
		direction_ray.force_raycast_update()
		if direction_ray.is_colliding():
			var normal = direction_ray.get_collision_normal()
			print(direction.slide(normal))
			return
		else:
			next_tile_cords = position + direction * cell_size
			print(str(position) + " ---> " + str(next_tile_cords))
	
