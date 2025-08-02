extends Control

var hearts = 3: set = setHearts
var maxHearts = 3: set = setMaxHearts

@onready var heartEmpty = $HeartEmpty
@onready var heartFull = $HeartFull

func setHearts(num):
	hearts = clamp(num, 0, maxHearts)
	if heartFull:
		heartFull.size.x = hearts * 15

func setMaxHearts(num):
	maxHearts = max(num, 1)
	if heartEmpty:
		heartEmpty.size.x = maxHearts * 15

func _ready():
	#self.max_hearts = PlayerStats
	pass
