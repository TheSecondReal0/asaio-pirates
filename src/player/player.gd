extends KinematicBody2D

export var speed_accel: float = 30.0
export var speed_decel: float = 10.0
export var speed_damp: float = 5.0
export var max_forward_speed: float = 100.0
export var max_backward_speed: float = 30.0
export var ang_accel: float = 30.0
export var ang_damp: float = 5.0
export var max_ang: float = 30.0
var min_ang: float = -max_ang

var movement_enabled: bool = true

var speed: float = 0.0
var angular_momentum: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta: float):
	if not movement_enabled:
		return
	var accel: float = 0.0
	var angular: float = 0.0
	if Input.is_action_pressed("up"):
		accel -= speed_accel * delta
	if Input.is_action_pressed("down"):
		accel += speed_decel * delta
	if Input.is_action_pressed("left"):
		angular -= ang_accel * delta
	if Input.is_action_pressed("right"):
		angular += ang_accel * delta
	speed += accel
	angular_momentum += angular
	if speed < 0:
		speed = max(speed, -max_forward_speed)
	else:
		speed = min(speed, max_backward_speed)
	angular_momentum = min(angular_momentum, max_ang)
	angular_momentum = max(angular_momentum, min_ang)
	rotation_degrees += angular_momentum * delta
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(cos(rotation), sin(rotation)) * speed)
	if speed < 0:
		speed += speed_damp * delta
		if speed > 0:
			speed = 0
	else:
		speed -= speed_damp * delta
		if speed < 0:
			speed = 0
	if angular_momentum < 0:
		angular_momentum += ang_damp * delta
		if angular_momentum > 0:
			angular_momentum = 0
	else:
		angular_momentum -= ang_damp * delta
		if angular_momentum < 0:
			angular_momentum = 0
