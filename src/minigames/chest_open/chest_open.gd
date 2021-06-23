extends Control

onready var chest: Node = $chest
onready var player: KinematicBody2D = get_node("../../player")

var quest_info: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
# warning-ignore:return_value_discarded
#	QuestServer.connect("quest_activated", self, "quest_activated")

# warning-ignore:unused_argument
func quest_activated(quest_name: String, new_quest_info: Dictionary):
	player.movement_enabled = false
	show()
	init_chest_open(new_quest_info)

func init_chest_open(new_quest_info: Dictionary):
	quest_info = new_quest_info
	chest.new_quest_info(new_quest_info)
	#chest.close_chest()

func _on_chest_chest_opened():
	pass
#	QuestServer.complete_quest(quest_info[QuestServer.info_keys.TEXT])
#	LootManager.add_gold(quest_info[QuestServer.info_keys.GOLD])
#	hide()
#	player.set_process(true)

func _on_chest_chest_closed():
	QuestServer.complete_quest(quest_info[QuestServer.info_keys.TEXT])
#	LootManager.add_gold(quest_info[QuestServer.info_keys.GOLD])
	hide()
	player.movement_enabled = true

func _on_buried_search_compass_minigame_quest_minigame_completed(quest_info):
	quest_activated(quest_info[QuestServer.info_keys.TEXT], quest_info)
