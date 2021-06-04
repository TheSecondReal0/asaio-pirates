extends Node

export var map_width: int = 2048
export var map_height: int = 2048
export var use_fixed_seed: bool = false
export var fixed_seed: int = 2360192022
export var mountain_threshold: float = .1
export var land_threshold: float = .15
export var settlement_threshold: float = .25

var simplex: OpenSimplexNoise = OpenSimplexNoise.new()
var simplex_seed: int = randi()#2360192022#randi()

var map_gen_order: PoolStringArray = ["Land", "Settlement"]

const tile_width: int = 64

var simplex_settings: Dictionary = {
	"Land": {
		"lacunarity": 2.0, 
		"octaves": 4, 
		"period": 24.0, 
		"persistence": 0.5
	}, 
	
	"Settlement": {
		"lacunarity": 2.0, 
		"octaves": 4, 
		"period": 12.0, 
		"persistence": 0.5
	}, 
}

signal map_generated(map_tile_types)

# Called when the node enters the scene tree for the first time.
func _ready():
	var top_left: Vector2 = Vector2(0, 0)
	var bot_right: Vector2 = Vector2(128, 128)
#	print(get_map_coords_between(top_left, bot_right))
#	print(smart_get_map_coords_between(top_left, bot_right))
#	if fixed_seed:
#		simplex_seed = fixed_seed
#	if get_tree().is_network_server():
#		rpc("receive_seed", simplex_seed)
#		generate_map()

func generate_map():
	print("generating map")
	var map_layers: Dictionary = {}
	for type in map_gen_order:
		config_simplex(type)
		map_layers[type] = gen_map_noise()
#	print(map_layers)
	var map_tile_types: Dictionary = {}
	var land_layer: Dictionary = map_layers["Land"]
	var settlement_layer: Dictionary = map_layers["Settlement"]
	for coord in land_layer:
		land_layer[coord] = pow(land_layer[coord], 2)
		#coord = land_layer[coord]
		if land_layer[coord] > land_threshold:
			if settlement_layer[coord] > settlement_threshold:
				map_tile_types[coord] = "Settlement"
				continue
			map_tile_types[coord] = "Land"
			continue
		else:# land_layer[coord] < land_threshold:
			map_tile_types[coord] = "Ocean"
			continue
#	for coord in map_coord_noise:
#		map_tile_types[coord] = noise_to_tile_type(map_coord_noise[coord])
	emit_signal("map_generated", map_tile_types)
	return map_tile_types

puppet func receive_seed(map_seed: int):
	simplex_seed = map_seed
	generate_map()

func gen_map_noise() -> Dictionary:
	var coord_noise = get_coord_noise()
	var map_noise: Dictionary = {}
	for coord in coord_noise:
		map_noise[coord] = coord_noise[coord]
	return map_noise

func get_coord_noise() -> Dictionary:
# warning-ignore:integer_division
# warning-ignore:integer_division
	var top_left: Vector2 = Vector2(map_width / 2, map_height / 2) * -1# * tile_width
	var bot_right: Vector2 = Vector2(map_width / 2, map_height / 2)# * tile_width
#	print(top_left)
#	print(bot_right)
	var map_coords: Array = smart_get_map_coords_between(top_left, bot_right)
#	print(map_coords)
	var coord_noise: Dictionary = {}
	for coord in map_coords:
			coord_noise[coord] = simplex.get_noise_2d(coord.x, coord.y)
	return coord_noise

func config_simplex(type: String):
	simplex.seed = simplex_seed
	for prop in simplex_settings[type]:
		simplex.set(prop, simplex_settings[type][prop])

#func get_map_coords_between(vec1: Vector2, vec2: Vector2) -> Array:
#	var top_left: Vector2 = Vector2(min(vec1.x, vec2.x), min(vec1.y, vec2.y))
#	var bot_right: Vector2 = Vector2(max(vec1.x, vec2.x), max(vec1.y, vec2.y))
#	var height: int = int(bot_right.y - top_left.y) / tile_width
#	var width1: int = int(bot_right.x - top_left.x) / tile_width
#	var width2: int = (int(bot_right.x - top_left.x) - 1) / tile_width
#	var coords: Array = []
#	for h in height:
#		if height % 2 == 0:
#			for w in width1:
#				coords.append(Vector2(tile_width * h, tile_width * w))
#		else:
#			for w in width2:
#				coords.append(Vector2(tile_width * h, (tile_width * w) + (tile_width / 2)))
#	return coords

func smart_get_map_coords_between(vec1: Vector2, vec2: Vector2) -> Array:
	var top_left: Vector2 = Vector2(min(vec1.x, vec2.x), min(vec1.y, vec2.y))
	var bot_right: Vector2 = Vector2(max(vec1.x, vec2.x), max(vec1.y, vec2.y))
	var height: int = int(bot_right.y - top_left.y) / tile_width
	var width: int = int(bot_right.x - top_left.x) / tile_width
	var coords: Array = []
	for h in height:
		if height % 2 == 0:
			for w in width:
				coords.append(Vector2(h, w))
	for i in coords.size():
		coords[i] = gen_map_coord(coords[i])
	return coords

func gen_map_coord(vec: Vector2) -> Vector2:
	if int(vec.y) % 2 == 0:
		return (vec * Vector2(1, .75)) * tile_width
	return ((vec * Vector2(1, .75)) + Vector2(.5, 0)) * tile_width
