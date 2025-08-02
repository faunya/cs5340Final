extends Area2D

var target = null
var hits = [] #queued up attacks to tkae damage from

func _on_HurtBox_area_entered(area):
	target = area
	if !hits.has(area):
		hits.append(area)

func _on_HurtBox_area_exited(area):
	target = null
