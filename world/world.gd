extends Node2D

@onready var hpUI = $GUI/HpUI
@onready var player = $ysort/Player

func _ready():
	hpUI.hearts = player.hp
	hpUI.maxHearts = player.maxHp
	UiSignals.hpUpdated.connect(hpUI.setHearts)
