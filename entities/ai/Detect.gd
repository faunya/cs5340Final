extends Area2D

var target = null

func hasTarget():
	return target != null

#func _on_Detect_body_entered(body):
#	target = body
#
#func _on_Detect_body_exited(body):
#	target = null


func _on_Detect_area_entered(area):
	target = area


func _on_Detect_area_exited(area):
	target = null
