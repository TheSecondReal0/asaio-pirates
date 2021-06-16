extends Node2D

export var can_close_chest: bool = true

onready var pirate_name_label: Label = $bottom/pirate_name

signal chest_opened
signal chest_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func new_quest_info(new_quest_info: Dictionary):
	pirate_name_label.text = new_quest_info[QuestServer.info_keys.PIRATE]
	close_chest(false)

func open_chest():
	$lid_open.show()
	$click_player.play()
	emit_signal("chest_opened")

func close_chest(emit_signal: bool = true):
	$lid_open.hide()
	if emit_signal:
		emit_signal("chest_closed")

func is_chest_open() -> bool:
	return $lid_open.visible

func _on_gui_click_detector_gui_input(event: InputEvent):
#	print("click detector")
	if not event is InputEventMouseButton:
		return
	event = event as InputEventMouseButton
	if event.button_index != BUTTON_LEFT:
		return
	if not event.pressed:
		return
	print("chest toggled")
	if not is_chest_open():
		open_chest()
	else:
		if can_close_chest:
			close_chest()
