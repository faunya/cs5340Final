extends CanvasLayer

var dialog# = $Dialog
@onready var interacting = false
@onready var buffer = false

func _ready():
	UiSignals.dialog_open.connect(on_dialog_open)
	UiSignals.dialog_close.connect(on_dialog_close)

func on_dialog_open(timeline):
	if !interacting:
		interacting = true

	if buffer:
		buffer = false
		interacting = false

func on_dialog_close():
	interacting = false
