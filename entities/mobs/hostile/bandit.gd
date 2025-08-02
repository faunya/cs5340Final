extends "res://entities/Entity.gd"

enum States {
	IDLE,
	WANDER,
	HURT,
	CHASE,
	ATTACK
}
#range of how long it takes for enemy to attack
@export var atkReactionLow = .5
@export var atkReactionHigh = 1

@export var atk = 1

@onready var reactionTimer = $reactionTimer
@onready var hitTimer = $hitTimer

var knockback = Vector2()
var target = null
var inAtkRange = false

func _ready():
	state = States.IDLE
	faceDir = Vector2()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	
	if hp == 0:
		queue_free()
	
	if faceDir.x < 0:
		pass #sprite.flip_h = true
	else:
		pass #sprite.flip_h = false
	
	#state machine
	match state:
		States.IDLE:
			idleState()
		States.HURT:
			hurtState()
		States.CHASE:
			chaseState(delta)
		States.ATTACK:
			attackState()

func idleState():
	if target:
		state = States.CHASE

func hurtState():
	pass

func chaseState(delta):
	if target && inAtkRange:
		reactionTimer.wait_time = randf_range(atkReactionLow, atkReactionHigh)
		reactionTimer.start()
		state = States.ATTACK
	else:
		state = States.IDLE

func attackState():
	pass


func _on_detect_area_entered(area):
	target = area

func _on_chase_area_exited(area):
	target = null

func _on_attack_area_entered(area):
	inAtkRange = true
	print("in range")

func _on_attack_area_exited(area):
	inAtkRange = false
	print("out range")

func _on_reaction_timer_timeout():
	print("timed out")
