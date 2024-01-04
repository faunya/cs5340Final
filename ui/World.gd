extends Node2D

var dialog #= $Dialog

@onready var interacting = false
@onready var buffer = false

func _ready():
	#dialog.timeline = ""
	UiSignals.connect("dialog_open", Callable(self, "on_dialog_open"))
	UiSignals.connect("dialog_close", Callable(self, "on_dialog_close"))

func _process(delta):
	pass

func on_dialog_open(timeline):
	if !interacting:
		#dialog.timeline = timeline
		dialog = Dialogic.start(timeline)
		dialog.connect("dialogic_signal", Callable(self, "_dialogListener"))
		add_child(dialog)
		
		interacting = true
	
	if buffer:
		buffer = false
		interacting = false

func on_dialog_close():
	interacting = false
	remove_child(dialog)

func _dialogListener(type):
	if type == "finished":
		buffer = true
