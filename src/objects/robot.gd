class_name Robot
extends GridMovementBody

@export var anim_sprite: AnimatedSprite2D
@export var console:Console
@export var agent:Player2AINPC
@export var ask_notification_array:Array[String]
@export var path_program: Array[Vector2]
var current_anim_name: String
var in_conversation:bool = false

func _ready() -> void:
	super()
	console.agent = agent
	console.exit.connect(exit)
	start_path()

func start_path():
	while !in_conversation:
		for dir in path_program:
			if in_conversation:direction = Vector2.ZERO;break
			direction = dir
			await get_tree().create_timer(2).timeout

func _physics_process(delta: float) -> void:
	super(delta)
	process_animation(direction)

func interact(initiator:Node):
	if !in_conversation:
		G.main.player.in_conversatin = true
		console.show()
		in_conversation = true

func exit():
	in_conversation = false
	start_path()
	G.main.player.in_conversatin = false

func process_animation(direction: Vector2):
	match direction:
		Vector2.UP:
			current_anim_name = "back"
		Vector2.DOWN:
			current_anim_name = "forward"
		Vector2.LEFT:
			current_anim_name = "left"
		Vector2.RIGHT:
			current_anim_name = "right"
		Vector2.ZERO:
			current_anim_name = ""
	if Vector2i(position) == Vector2i(next_tile_cords):
		anim_sprite.stop()
		return
	if current_anim_name != "":
		anim_sprite.play(current_anim_name)
	else:
		anim_sprite.stop()
		anim_sprite.frame = 0
