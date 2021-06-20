extends Control

onready var quests_list: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	QuestServer.connect("new_quest", self, "new_quest")
# warning-ignore:return_value_discarded
	QuestServer.connect("quest_completed", self, "quest_completed")
	for quest in QuestServer.quests:
		new_quest(quest, QuestServer.quests[quest])

func new_quest(quest_name: String, _quest_info: Dictionary):
	print("creating new quest label: ", quest_name)
	#print("new quest")
	var label: Label = Label.new()
	label.set("custom_colors/font_color", Color(0, 0, 0, 1))
	label.text = quest_name
	label.name = quest_name
	quests_list.add_child(label)

func quest_completed(quest_name: String, _quest_info: Dictionary):
	quests_list.get_node(quest_name).queue_free()
