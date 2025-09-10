@tool
extends Control
class_name Console

@export var rich_text:RichTextLabel
@export var edit:LineEdit
@export var shell_prompt_label:Label

@export var shell_prompt:String = "user@aos: ~$ ":
	set(value):
		shell_prompt = value
		shell_prompt_label.text = value
	get(): return shell_prompt

func _ready() -> void:
	_on_visibility_changed()

func push_text(text:String):
	rich_text.text += shell_prompt + text + "\n"

func _on_line_edit_text_submitted(new_text: String) -> void:
	push_text(new_text)
	edit.text = ""


func _on_visibility_changed() -> void:
	if !is_inside_tree():return
	if visible:
		edit.grab_focus()
	else:edit.release_focus()
