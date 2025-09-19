class_name Console
extends Control

signal exit

@export var exit_button: TextureButton
@export var rich_text: RichTextLabel
@export var edit: LineEdit
@export var shell_prompt_label: Label

@export var shell_prompt: String = "@AIOS: ~$ "
@export var close_window:AudioStreamPlayer
@onready var pushed_sound: AudioStreamPlayer2D = $pushed_sound
@onready var enter: AudioStreamPlayer = $enter

func _ready() -> void:
	_on_visibility_changed()

	exit_button.button_up.connect(func(): exit.emit();hide();close_window.play())
	edit.text_submitted.connect(_on_line_edit_text_submitted)
	draw.connect(func():enter.play())
	
	shell_prompt_label.text = G.data.user_name + shell_prompt


func push_text(shell_prompt: String, text: String):
	pushed_sound.play()
	rich_text.text += shell_prompt + text + "\n"
	shell_prompt_label.text = G.data.user_name + self.shell_prompt


func _on_line_edit_text_submitted(new_text: String) -> void:
	push_text("[color=green]" + G.data.user_name + shell_prompt + "[/color]", new_text)
	edit.text = ""

func _on_visibility_changed() -> void:
	if !is_inside_tree(): return
	if visible:
		edit.grab_focus()
	else: edit.release_focus()
