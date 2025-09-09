extends Node
class_name Main

@export var main_menu:PackedScene
@export var worlds:Array[PackedScene]
@export var world:Node
func  _ready() -> void:
	G.main = self

func load_world(index:int = 0):
	get_tree().paused = true
	var instace = worlds[index].instantiate()
	if world:
		world.queue_free()
		await get_tree().process_frame
	world = instace
	add_child(world)
	get_tree().paused = false
