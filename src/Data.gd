class_name Data 
extends Resource

@export_range(0, 1, .01) var sfx: float = 0.25
@export_range(0, 1, .01) var music: float = 0.25

func save() -> void:
	ResourceSaver.save(self, "user://gamedata.tres")

static  func load_or_create() -> Data:
	var res: Data = load("user://gamedata.tres") as Data
	if !res:
		res = Data.new()
	return res
