extends Node

var gold: int = 0

signal gold_updated(gold_amount, change)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_gold(amount: int):
	gold += amount
	emit_signal("gold_updated", gold, amount)

func remove_gold(amount: int):
	gold -= amount
	emit_signal("gold_updated", gold, -amount)
