extends VBoxContainer

onready var label: Label = $plunder

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	LootManager.connect("gold_updated", self, "gold_updated")

func gold_updated(amount: int, _change: int):
	label.text = "Plunder: " + str(amount)
