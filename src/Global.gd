extends Node

var main:Main
var data:Data = Data.load_or_create()

@onready var main_scene:PackedScene = load("res://src/main.tscn")
