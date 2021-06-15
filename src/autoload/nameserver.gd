extends Node

var island_names: PoolStringArray = []
var pirate_names: PoolStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	for _i in 50:
#		print(get_random_island_name())

func get_random_pirate_name(unique: bool = false) -> String:
	var titles: PoolStringArray = ["Captain", "Dread Pirate", "One-Eyed", "Quartermaster"]
	var first_names: PoolStringArray = ["Robert", "Jack", "William", "James", "Bart", "Henry", "Edward", "Duncan"]
	var last_names: PoolStringArray = ["Roberts", "Kidd", "Morgan", "Kenway"]
	var all_names: PoolStringArray = first_names + last_names
	var exclude: Array = []
	if unique:
		exclude = pirate_names
	var pirate_name: String = gen_name(titles, " ", all_names, exclude)
	return pirate_name

func get_random_island_name() -> String:
	var begin_locations: PoolStringArray = ["Isle", "Bay", "Cave"]
	var end_locations: PoolStringArray = ["Bay", "Cay", "Isle", "Cavern", "Cove"]
	var begin_phrases: PoolStringArray = ["Smuggler's", "Rumrunner", "Lost", "Mermaid", "Glittering", "Kraken's", "Shipwreck", "Dead Man's"]
	var end_phrases: PoolStringArray = ["Lost Treasure", "the Damned", "Whispers", "Rum"]
	var start_with_phrase: bool = true
	var rand_list: Array = []
	for _i in begin_locations:
		rand_list.append(false)
	for _i in end_locations:
		rand_list.append(true)
	start_with_phrase = Helpers.pick_random(rand_list)
	var island_name: String
	if start_with_phrase:
		island_name = gen_name(begin_phrases, " ", end_locations, island_names)
		if island_name == "":
			island_name = gen_name(begin_locations, " of ", end_phrases, island_names)
	else:
		island_name = gen_name(begin_locations, " of ", end_phrases, island_names)
		if island_name == "":
			island_name = gen_name(begin_phrases, " ", end_locations, island_names)
	if island_name != "":
		island_names.append(island_name)
	return island_name

func gen_name(beginnings: Array, join: String, endings: Array, exclude: Array):
	var begin_index: int = randi() % beginnings.size()
	var end_index: int = randi() % endings.size()
	var current_begin_index: int = begin_index
	var current_end_index: int = end_index
	var current_beginning: String = beginnings[current_begin_index]
	var current_ending: String = endings[current_end_index]
	var new_name: String = current_beginning + join + current_ending
	while new_name in exclude:
		current_end_index += 1
		current_end_index = current_end_index % endings.size()
		if current_end_index == end_index:
			current_begin_index += 1
			current_begin_index = current_begin_index % beginnings.size()
			if current_begin_index == begin_index:
				return ""
		current_beginning = beginnings[current_begin_index]
		current_ending = endings[current_end_index]
		new_name = current_beginning + join + current_ending
	return new_name
