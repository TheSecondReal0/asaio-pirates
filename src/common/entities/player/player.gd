extends KinematicBody2D

export var active: bool = false
export var top_left_bound: Vector2 = Vector2(0, 0)
export var bot_right_bound: Vector2 = Vector2(300, 300)

var speed: int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta: float):
	if not active:
		return
	var move: Vector2 = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		move += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("left"):
		move += Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		move += Vector2(1, 0)
# warning-ignore:unused_variable
	var moved: Vector2 = move_and_slide(move * speed)
	if  position.x < top_left_bound.x:
		position.x = top_left_bound.x
	if  position.y < top_left_bound.y:
		position.y = top_left_bound.y
	if  position.x > bot_right_bound.x:
		position.x = bot_right_bound.x
	if  position.y > bot_right_bound.y:
		position.y = bot_right_bound.y
