extends Node2D

var resources: Dictionary = ResourceManager.get_tile_resources()

var reference_sprite: Sprite = Sprite.new()
var sprite_texture = load("res://common/textures/hexagons/white_hex_outlined_32x32.png")#load("res://common/textures/hexagons/white_hex_32x32.png")

var place_tile_queue: Array = []
var map_created: bool = false

var map_start_time: int
var map_end_time: int

export var tiles_per_frame: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	reference_sprite.texture = sprite_texture
	reference_sprite.z_index = -3
	#var coords: Array = MapServer.smart_get_map_coords_between(Vector2(0, 0), Vector2(2048, 2048))
	var map_tile_types: Dictionary = MapServer.generate_map()
	for coord in map_tile_types:
		queue_place_tile(coord, map_tile_types[coord])

# warning-ignore:unused_argument
func _process(delta):
	if place_tile_queue.empty():
		if not map_created:
			print("map created")
			map_created = true
			map_end_time = OS.get_system_time_msecs()
			if map_start_time == null:
				print("map start time is null")
				return
			print(float(map_end_time - map_start_time) / 1000)
		return
	for _i in tiles_per_frame:
		if place_tile_queue.empty():
			if not map_created:
				print("map created")
				map_created = true
				map_end_time = OS.get_system_time_msecs()
				print(float(map_end_time - map_start_time) / 1000)
			return
		var args: Array = place_tile_queue.pop_front()
		place_tile(args[0], args[1])

func queue_place_tile(pos: Vector2, type: String):
	place_tile_queue.append([pos, type])

func place_tile(pos: Vector2, type: String):
	var tile: Node2D = create_tile(type)
	tile.global_position = pos
	add_child(tile)

func create_tile(type: String):
	return resources[type].gen_tile()

func create_sprite(pos: Vector2):
	var sprite: Sprite = reference_sprite.duplicate()
	add_child(sprite)
	sprite.position = pos
