extends Node

var tile_resource_dir: String = "res://environment/tiles/"

func get_tile_resources():
	var _resources: Array = Helpers.load_files_in_dir_with_exts(tile_resource_dir, [".tres"])
	var res_dict: Dictionary = {}
	for res in _resources:
		res_dict[res.type] = res
	return res_dict
