extends "res://entities/Entity.gd"

# Called when the node enters the scene tree for the first time.
var interactable
var mouseIn

var selected

func _ready():
	interactable = false
	mouseIn = false
	selected = false

func _physics_process(delta):
	if interactable:
		if Input.is_action_just_pressed("interact") && mouseIn: # && !interacting:
			UiSignals.emit_signal("dialog_open","dummytest")
			
		elif Input.is_action_just_pressed("cancel"):
			UiSignals.emit_signal("dialog_close")

func _on_Interact_area_entered(area):
	interactable = true

func _on_InteractArea_area_exited(area):
	interactable = false
	UiSignals.emit_signal("dialog_close")

func _on_mouse_area_mouse_entered():
	mouseIn = true

func _on_mouse_area_mouse_exited():
	mouseIn = false
