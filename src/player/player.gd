extends GridMovementBody
class_name Player

@export var interaction_ray:RayCast2D
@export var can_move:bool = true

func _ready() -> void:
	super()
	G.main.player = self

func _physics_process(delta: float) -> void:
	if !can_move:return
	super(delta)
	interaction_ray.rotation = old_direction.angle() - PI / 2

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		interaction_ray.force_raycast_update()
		if interaction_ray.is_colliding():
			var collider:Node2D = interaction_ray.get_collider()
			var parent:Node = collider.get_parent()
			if parent.has_method("interact"):
				parent.interact()
				print("interact with: " + str(parent))
