extends Node2D

var player = null

func _on_Timer_timeout():
	end()

func end():
	if player:
		player.shdwList.erase(self)
	queue_free()
