extends Node2D

@export var console:Console
@export var screen:Label
var in_use:bool = false

func _ready() -> void:
	console.agent = G.main.MainProgram
	console.exit.connect(exit)
	update_screen()

func interact():
	if !in_use:
		G.main.player.can_move = false
		console.show()
		in_use = true

func exit():
	console.hide()
	in_use = false
	G.main.player.can_move = true
	update_screen()


func update_screen():
	screen.text = ""
	for i in [3,2,1,0]:
		screen.text += (get_last_lines(console.rich_text,i) + "\n").replace(console.agent.character_name + console.shell_prompt,"")

func get_last_lines(label: RichTextLabel, index: int) -> String:
	var lines = label.get_parsed_text().split("\n")
	lines.reverse()
	if index >= 0 and index < lines.size():
		return lines[index]
	return ""
