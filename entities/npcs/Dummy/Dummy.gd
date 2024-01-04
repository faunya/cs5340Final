extends "res://entities/Entity.gd"

# Called when the node enters the scene tree for the first time.
@onready var interactable = false

@onready var selected = false

func _ready():
	pass


func _physics_process(delta):
	if interactable:
		if Input.is_action_just_pressed("interact"): # && !interacting:
			UiSignals.emit_signal("dialog_open","dummy-test")
			startDialog()
		elif Input.is_action_just_pressed("cancel"):
			UiSignals.emit_signal("dialog_close")

func _on_Interact_area_entered(area):
	interactable = true

func _on_InteractArea_area_exited(area):
	interactable = false
	UiSignals.emit_signal("dialog_close")

func startDialog():
	pass
