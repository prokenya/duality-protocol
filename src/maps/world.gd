extends Node2D
class_name World


@export var shader_material: ShaderMaterial

func _process(_delta: float) -> void:
	var cam := get_viewport().get_camera_2d()
	if not cam or not shader_material:
		return

	var vp_size := get_viewport().get_visible_rect().size

	shader_material.set_shader_parameter("camera_pos", cam.global_position)
	shader_material.set_shader_parameter("camera_zoom", cam.zoom)
	shader_material.set_shader_parameter("viewport_size", vp_size)
