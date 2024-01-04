extends CanvasLayer

@onready var dialog# = $Dialog

@onready var interacting = false
@onready var buffer = false

func _ready():
	#dialog.timeline = ""
	#print(dialog)
	#Dialogic.change_timeline("dummy-test")
	
	UiSignals.connect("dialog_open", Callable(self, "on_dialog_open"))
	UiSignals.connect("dialog_close", Callable(self, "on_dialog_close"))

func on_dialog_open(timeline):
	if !interacting:
		#dialog.timeline = timeline
		print("yea")
#		dialog.pause_mode = PAUSE_MODE_PROCESS
#		dialog.connect("dialogic_signal", self, "_dialogListener")
#		call_deferred('add_child', dialog)

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
