extends Node

var tile_width: int = MapGenerator.tile_width

var map_tile_types: Dictionary = {}

# {"island name": [tile group]}
var islands: Dictionary

signal islands_list_generated(islands)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	MapGenerator.connect("map_generated", self, "map_generated")
	print(get_adjacent_tiles(Vector2(0, 0)))

func map_generated(tile_types: Dictionary):
	map_tile_types = tile_types
	gen_island_list()
#	print(islands)

func gen_island_list():
	var island_tile_groups: Array = find_island_tile_groups()
	for tile_group in island_tile_groups:
		islands[NameServer.get_random_island_name()] = tile_group
	emit_signal("islands_list_generated", islands)

func find_island_tile_groups() -> Array:
	var island_groups: Array = []
	for coord in map_tile_types:
		if map_tile_types[coord] == "Land":
			var already_used: bool = false
			for tile_group in island_groups:
				if coord in tile_group:
					already_used = true
					break
			if already_used:
				continue
			var island_coords: PoolVector2Array = get_tile_type_group(coord, "Land").keys()
#			if not island_coords in island_groups:
			island_groups.append(island_coords)
	return island_groups

func get_tile_type_group(coord: Vector2, type: String, excluded: Array = []) -> Dictionary:
	var tiles: Dictionary = {}
	var to_check: Array = [coord]
	while not to_check.empty():
		for vec in to_check:
			var adjacent: Dictionary = get_adjacent_tiles_of_type(vec, type, true)
			for tile_coord in adjacent:
				if tile_coord in tiles:
					continue
				tiles[tile_coord] = adjacent[tile_coord]
				to_check.append(tile_coord)
			to_check.erase(vec)
	for coord in tiles:
		if coord in excluded:
# warning-ignore:return_value_discarded
			tiles.erase(coord)
	return tiles

func get_adjacent_tiles_of_type(coord: Vector2, type: String, include_self: bool = false) -> Dictionary:
	var tiles: Dictionary = {}
	var adjacent: Dictionary = get_adjacent_tiles(coord)
	if include_self:
		adjacent[coord] = type
	for coord in adjacent:
		if adjacent[coord] == type:
			tiles[coord] = adjacent[coord]
	return tiles

func get_adjacent_tiles(coord: Vector2, include_self: bool = false) -> Dictionary:
	var coords: Array = []
	coords.append(coord - Vector2(tile_width, 0))
	coords.append(coord + Vector2(tile_width, 0))
	coords.append(coord - Vector2(tile_width * .5, tile_width * .75))
	coords.append(coord + Vector2(tile_width * .5, tile_width * .75))
	coords.append(coord - Vector2(tile_width * .5, -tile_width * .75))
	coords.append(coord + Vector2(tile_width * .5, -tile_width * .75))
	if include_self:
		coords.append(coord)
	var tiles: Dictionary = {}
	for vec in coords:
		if vec in map_tile_types:
			tiles[vec] = map_tile_types[vec]
	return tiles

func get_map_coords_between(vec1: Vector2, vec2: Vector2) -> Array:
	var top_left: Vector2 = Vector2(min(vec1.x, vec2.x), min(vec1.y, vec2.y))
	var bot_right: Vector2 = Vector2(max(vec1.x, vec2.x), max(vec1.y, vec2.y))
# warning-ignore:integer_division
	var height: int = int(bot_right.y - top_left.y) / tile_width
# warning-ignore:integer_division
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
