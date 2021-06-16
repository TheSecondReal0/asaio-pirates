extends Node2D

var island_name: String
var island_group: PoolVector2Array
# {"quest name": {quest info key: value}}
var quest_names: PoolStringArray = []
var quests: Dictionary = {}

onready var area2d: Area2D = $Area2D

func _ready():
	area2d.get_node("CollisionPolygon2D").polygon = gen_hex_coords(MapGenerator.tile_width)
# warning-ignore:return_value_discarded
	area2d.connect("body_entered", self, "_on_area_body_entered")
# warning-ignore:return_value_discarded
	QuestServer.connect("new_quest", self, "new_quest")
# warning-ignore:return_value_discarded
	QuestServer.connect("quest_completed", self, "quest_completed")
	init_tile()

func new_quest(quest_name: String, quest_info: Dictionary):
	if not quest_name in quest_names:
		quest_names.append(quest_name)
	if not quest_name in quests:
		quests[quest_name] = quest_info

func quest_completed(quest_name: String, _quest_info: Dictionary):
	for i in quest_names.size():
		if quest_names[i] == quest_name:
			quest_names.remove(i)
			break
# warning-ignore:return_value_discarded
	quests.erase(quest_name)

func init_tile():
	island_name = MapServer.get_island_at(global_position)
	island_group = MapServer.islands[island_name]
	if island_name in QuestServer.quests_by_island:
		quest_names = QuestServer.quests_by_island[island_name]
	for quest_name in quest_names:
		quests[quest_name] = QuestServer.quests[quest_name]

func _on_area_body_entered(body: Node):
	if not body.name == "player":
		return
	print("player anchored at " + island_name)
	print(quest_names)
	if not quest_names.size() > 0:
		return
	while not QuestServer.quests.has(quest_names[0]):
		quest_names.remove(0)
		if quest_names.size() < 1:
			break
	if not quest_names.size() > 0:
		return
	QuestServer.activate_quest(quest_names[0])

func gen_hex_coords(tile_width: float) -> PoolVector2Array:
	var radius: float = tile_width * .5
	var x_offset: float = (sqrt(3) / 2.0) * radius
	var y_offset: float = .5 * radius
	var coords: PoolVector2Array = []
	coords.append(Vector2(0, -radius))
	coords.append(Vector2(x_offset, -y_offset))
	coords.append(Vector2(x_offset, y_offset))
	coords.append(Vector2(0, radius))
	coords.append(Vector2(-x_offset, y_offset))
	coords.append(Vector2(-x_offset, -y_offset))
	return coords
