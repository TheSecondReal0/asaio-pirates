extends Control


onready var enviro: Node2D = $buried_search_compass_environment
onready var player: KinematicBody2D = $buried_search_compass_environment/player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
