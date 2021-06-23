extends Control

export var clunk_delay: float = .4

onready var player: KinematicBody2D = get_node("../../player")
onready var enviro: Node2D = $buried_search_compass_environment
onready var mini_player: KinematicBody2D = $buried_search_compass_environment/player

onready var dig_sound: AudioStreamPlayer = $dig_sound
onready var clunk_sound: AudioStreamPlayer = $clunk_sound

var treasure_pos: Vector2
var treasure_range: int = 15

var quest_info: Dictionary

var treasure_found: bool = false
var time_since_treasure_found: float = 0.0

signal quest_minigame_completed(quest_info)

func _ready():
	mini_player.active = true
# warning-ignore:return_value_discarded
	QuestServer.connect("quest_activated", self, "quest_activated")

func _process(_delta: float):
	if not visible:
		return
	if treasure_found:
		if time_since_treasure_found >= clunk_delay:
			clunk_sound.play()
			treasure_found = false
			time_since_treasure_found = 0.0
			hide()
			emit_signal("quest_minigame_completed", quest_info)
		else:
			time_since_treasure_found += _delta
			print(time_since_treasure_found)
	if not Input.is_action_just_pressed("special1"):
		return
	dig_sound.play()
	if mini_player.position.distance_to(treasure_pos) <= treasure_range:
		#clunk_sound.play()
		treasure_found = true
		print("found treasure bb")

func quest_activated(quest_name: String, new_quest_info: Dictionary):
	player.movement_enabled = false
	show()
	init_compass_buried_search(new_quest_info)

func init_compass_buried_search(new_quest_info: Dictionary):
	quest_info = new_quest_info
	treasure_pos = get_random_pos_in_range()
	mini_player.position = get_random_pos_in_range()

func get_random_pos_in_range() -> Vector2:
	return Vector2(rand_range(0, $background.rect_size.x), rand_range(0, $background.rect_size.y))
