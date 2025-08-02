extends Camera2D

const MAXDISTX = 32
const MAXDISTY = 48
var targetDist = 0
var centerPos = position

@export var locked = true

func _process(delta):
	if Input.is_action_just_pressed("camera_lock"):
		locked = !locked
		
	const maxDistVector = Vector2(MAXDISTX, MAXDISTY)
	
	var targetPos
	if locked:
		targetPos = centerPos
	else:
		var dir = centerPos.direction_to(get_local_mouse_position())
		targetPos = centerPos + dir * targetDist
	
	targetPos = targetPos.clamp(centerPos - maxDistVector, 
								centerPos + maxDistVector)
	
	position = targetPos

func _input(event):
	if event is InputEventMouseMotion:
		targetDist = centerPos.distance_to(get_local_mouse_position()) / 2
