extends GridMovementBody
class_name Player

@export var interaction_ray:RayCast2D
@export var in_conversatin:bool = false

@export var anim_sprite:AnimatedSprite2D
var current_anim_name:StringName
var last_action:String = ""

func _ready() -> void:
	super()
	G.main.player = self

func _physics_process(delta: float) -> void:
	if in_conversatin:return
	
	direction = Input.get_vector("left", "right", "up", "down").sign()
	super(delta)
	interaction_ray.rotation = direction_of_view.angle() - PI / 2
	process_animation(direction)
	
	var action_to_anim := {
		"left": "left",
		"right": "right",
		"up": "back",
		"down": "forward"
	}
	
	for action in action_to_anim.keys():
		if Input.is_action_just_pressed(action):
			last_action = action_to_anim[action]
			break

		
#func process_animation(direction:Vector2):
	#match direction:
		#Vector2.UP:
			#current_anim_name= "back"
		#Vector2.DOWN:
			#current_anim_name = "forward"
		#Vector2.LEFT:
			#current_anim_name = "left"
		#Vector2.RIGHT:
			#current_anim_name = "right"
		#Vector2.ZERO:
			#current_anim_name = ""
func process_animation(direction:Vector2):
	current_anim_name = last_action
	
	if Vector2i(position) == Vector2i(next_tile_cords):
		anim_sprite.stop()
	if current_anim_name != "":
		anim_sprite.play(current_anim_name)
	else:
		anim_sprite.stop()
		anim_sprite.frame = 0
			
			
			

func _input(event: InputEvent) -> void:
	if in_conversatin:return
	if Input.is_action_just_pressed("interact"):
		interaction_ray.force_raycast_update()
		if interaction_ray.is_colliding():
			var collider:Node2D = interaction_ray.get_collider()
			var parent:Node = collider.get_parent()
			if parent.has_method("interact"):
				parent.interact(self)
				print("interact with: " + str(parent))
