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
@onready var pivot = $Pivot
@onready var weapon = $Pivot/Weapon

var knockback = Vector2()
var target = null
var inAtkRange = false

func _ready():
	state = States.IDLE
	faceDir = Vector2()
	
	if weapon:
		weapon.connect("animFinished", finishedAtkAnim)

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

func finishedAtkAnim():
	state = States.IDLE


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
	if !weapon || !target:
		return
	
	var vectorToTarget = target.global_position - pivot.global_position
	vectorToTarget = vectorToTarget.normalized()
	
	var attackVector = Vector2(roundi(vectorToTarget.x), roundi(vectorToTarget.y))
	var attackAngle = getAttackAngle(attackVector)
	
	var hDir = -1 if absf(vectorToTarget.x + 1) < absf(vectorToTarget.x - 1) \
		else 1 
	if hDir == -1: # left
		weapon.playAtkLeft() 
		pivot.rotation = deg_to_rad(attackAngle)
	else: #right
		weapon.playAtkRight()
		pivot.rotation = deg_to_rad(-1 * attackAngle)
	

func getAttackAngle(attackVector):
	var attackAngle
	match attackVector:
		Vector2(1, 0), Vector2(-1, 0): #right, left
			attackAngle = 0
		Vector2(0, -1): #up
			attackAngle = 90
		Vector2(0, 1): #down
			attackAngle = 270
		Vector2(1,1), Vector2(-1, 1):#down right, down left
			attackAngle = 315
		Vector2(1, -1), Vector2(-1, -1): #up right, up left
			attackAngle = 45
		_:
			attackAngle = 0
	
	return attackAngle
