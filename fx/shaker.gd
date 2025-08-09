class_name Shaker extends RefCounted

var target: Node2D
var startingPos: Vector2

@export var shakes = 4;

func _init(newTarget: Node2D) -> void:
	target = newTarget
	startingPos = target.position
	
func shake(amount: float, duration: float):
	for i in shakes: 
		target.position = startingPos + \
			Vector2(randi_range(-amount, amount), randi_range(-amount, amount))
		await target.get_tree().create_timer(duration / shakes).timeout
		amount -= (amount / shakes)
	
	target.position = startingPos
