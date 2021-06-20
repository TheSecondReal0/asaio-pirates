extends Node

var islands: Dictionary = MapServer.islands

# {"quest name": {quest info key: info}}
var quests: Dictionary = {}
# {"island name": "quest name"}
var quests_by_island: Dictionary = {}

enum info_keys {ISLAND, GOLD, PIRATE, TEXT, TYPE}
enum quest_types {BURIED_TREASURE, SHIPWRECK}

signal new_quest(quest_name, quest_info)
signal quest_completed(quest_name, quest_info)
signal quest_activated(quest_name, quest_info)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	MapServer.connect("islands_list_generated", self, "islands_list_generated")

func islands_list_generated(_islands: Dictionary):
	for _i in 3:
# warning-ignore:return_value_discarded
		new_quest()

func activate_quest(quest_name: String):
	emit_signal("quest_activated", quest_name, quests[quest_name])

func new_quest() -> String:
	print("creating new quest")
	var island: String = islands.keys()[randi() % islands.keys().size()]
	while island in quests_by_island:
		island = islands.keys()[randi() % islands.keys().size()]
	var pirate_name: String = NameServer.get_random_pirate_name()
	var quest_name: String = pirate_name + "'s "
	quest_name += Helpers.pick_random(["Buried Treasure", "Hidden Booty", "Shiny Doubloons", "Glittering Gold", "Prized Possessions"])
	quest_name += " of "
	if " of " in island:
		quest_name += "the "
	quest_name += island
	var quest_info: Dictionary = {}
	quest_info[info_keys.ISLAND] = island
	quest_info[info_keys.GOLD] = randi() % 500 + 300
	quest_info[info_keys.PIRATE] = pirate_name
	quest_info[info_keys.TEXT] = quest_name
	quests[quest_name] = quest_info
	if not island in quests_by_island:
		quests_by_island[island] = []
	quests_by_island[island].append(quest_name)
	emit_signal("new_quest", quest_name, quest_info)
	print("quest created: ", quest_name)
	return quest_name

func complete_quest(quest_name: String):
	LootManager.add_gold(quests[quest_name][info_keys.GOLD])
	print("quest completed: ", quest_name)
	emit_signal("quest_completed", quest_name, quests[quest_name])
	quests_by_island[quests[quest_name][info_keys.ISLAND]].erase(quest_name)
# warning-ignore:return_value_discarded
	quests.erase(quest_name)
	new_quest()
