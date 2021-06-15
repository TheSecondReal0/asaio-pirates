extends Node

var islands: Dictionary = MapServer.islands

# {"quest name": {quest info key: info}}
var quests: Dictionary = {}
# {"island name": "quest name"}
var quests_by_island: Dictionary = {}

enum info_keys {ISLAND, GOLD}

signal new_quest(quest_name)
signal quest_completed(quest_name)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	MapServer.connect("islands_list_generated", self, "islands_list_generated")

func islands_list_generated(_islands: Dictionary):
	for _i in 3:
		new_quest()

func new_quest() -> String:
	var island: String = islands.keys()[randi() % islands.keys().size()]
	while island in quests_by_island:
		island = islands.keys()[randi() % islands.keys().size()]
	var quest_name: String = NameServer.get_random_pirate_name() + "'s "
	quest_name += Helpers.pick_random(["Buried Treasure", "Hidden Booty", "Shiny Doubloons", "Glittering Gold", "Prized Possessions"])
	quest_name += " of "
	if " of " in island:
		quest_name += "the "
	quest_name += island
	var quest_info: Dictionary = {}
	quest_info[info_keys.ISLAND] = island
	quest_info[info_keys.GOLD] = randi() % 500 + 300
	quests[quest_name] = quest_info
	quests_by_island[island] = quest_name
	emit_signal("new_quest", quest_name)
	return quest_name

func complete_quest(quest_name: String):
	emit_signal("quest_completed", quest_name)
	quests_by_island[quests[quest_name][info_keys.ISLAND]].erase(quest_name)
# warning-ignore:return_value_discarded
	quests.erase(quest_name)
