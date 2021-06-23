extends Control

export var spin_speed: int = 360

#onready var treasure_pos: Vector2 = get_parent().treasure_pos
onready var treasure_range: int = get_parent().treasure_range

onready var player: KinematicBody2D = get_node("../buried_search_compass_environment/player")
onready var needle: Node2D = $needle

func _ready():
	pass # Replace with function body.

func _process(delta: float):
	var angle_to: float = rad2deg((player.position - get_treasure_pos()).angle())#rad2deg(player.position.angle_to(treasure_pos))
	#print(angle_to)
	#print(player.position, " and ", treasure_pos)
	var distance_to: float = player.position.distance_to(get_treasure_pos())
	#print(distance_to)
	if distance_to <= treasure_range:
		needle.rotation_degrees += spin_speed * delta
		return
	needle.rotation_degrees = angle_to - 90

func get_treasure_pos() -> Vector2:
	return get_parent().treasure_pos
