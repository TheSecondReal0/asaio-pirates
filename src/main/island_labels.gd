extends Node2D

var centered_label_scene: PackedScene = load("res://common/presets/labels/centered_label/centered_label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	MapServer.connect("islands_list_generated", self, "islands_list_generated")
	islands_list_generated(MapServer.islands)

func islands_list_generated(islands: Dictionary):
	print("generating labels")
	for island_name in islands:
		create_label(island_name, average_coords(islands[island_name]))

func create_label(text: String, pos: Vector2):
	var label: Label = centered_label_scene.instance()
	label.set("custom_colors/font_color", Color(0, 0, 0, 1))
	label.text = text
	add_child(label)
	label.rect_position += pos

func average_coords(coords: PoolVector2Array) -> Vector2:
	var sum: Vector2 = Vector2(0, 0)
	for coord in coords:
		sum += coord
	return sum / coords.size()
