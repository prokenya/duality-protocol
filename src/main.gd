extends Node
class_name Main

@export var main_menu:PackedScene
@export var worlds:Array[PackedScene]
@export var world:Node

@export var MainProgram:Player2AINPC
@export var duality_protocol_status:bool = false

@export var player:Player
func  _ready() -> void:
	G.main = self
	if G.data.first_run:
		G.data.user_name = get_username()
	G.data.first_run = false
	G.data.save()

func get_username() -> String:
	var output = []
	
	if OS.get_name() == "Windows":
		OS.execute("cmd", ["/c", "echo %USERNAME%"], output)
	else:
		OS.execute("sh", ["-c", "echo $USER"], output)
	
	if output.size() > 0:
		return output[0].strip_edges()
	
	return "user"

func load_world(index:int = 0):
	get_tree().paused = true
	var instace = worlds[index].instantiate()
	if world:
		world.queue_free()
		await get_tree().process_frame
	world = instace
	add_child(world)
	get_tree().paused = false
