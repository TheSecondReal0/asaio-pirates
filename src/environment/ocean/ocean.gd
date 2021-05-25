extends CanvasLayer

onready var ocean: Node = $ColorRect

var current_coord: Vector2 = Vector2(100, 0)

#func _process(_delta):
#	current_coord += Vector2(0.0003 * _delta, 0)
#	set_offset_coord(current_coord)

func set_offset_coord(coord: Vector2):
	ocean.get_material().set_shader_param("offset_coord", coord)
