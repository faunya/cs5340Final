extends "res://entities/Entity.gd"

enum States {
	IDLE,
	WANDER,
	HURT,
	CHASE,
	ATTACK
}
#range of how long it takes for enemy to attack
@export var atkReactionLow = 1
@export var atkReactionHigh = 1

@export var atk = 1

@onready var animPlayer = $AnimPlayer
@onready var fxAnimPlayer = $fxAnimPlayer

@onready var reactionTimer = $reactionTimer
@onready var hitTimer = $hitTimer
@onready var pivot = $Pivot
@onready var weapon = $Pivot/Weapon

var knockback = Vector2()
var target = null
var inAtkRange = false
var moveDir = Vector2.ZERO

func _ready():
	hp = maxHp
	state = States.IDLE
	
	if weapon:
		weapon.connect("animFinished", finishedAtkAnim)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	
	if hp == 0:
		pass#queue_free()
	
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
	playIdleMoveAnim()
	if target:
		state = States.CHASE

func hurtState():
	pass

func chaseState(delta):
	if target && inAtkRange:
		reactionTimer.wait_time = randf_range(atkReactionLow, atkReactionHigh)
		reactionTimer.start()
		state = States.ATTACK
	elif target && !inAtkRange:
		#if softCollision.isColliding():
		#	moveDir += softCollision.getPushVector() * delta * 400
		
		if moveDir != Vector2():
			movement(delta, moveDir)
	else:
		state = States.IDLE

func attackState():
	if !inAtkRange:
		state = States.CHASE

func finishedAtkAnim():
	state = States.IDLE

func playIdleMoveAnim():
	if (moveDir != Vector2.ZERO):
		if (hDir == -1): #face left
			animPlayer.play("walkLeft")
		else: #face right
			animPlayer.play("walkRight")
	else:
		if (hDir == -1): #face left
			animPlayer.play("idleLeft")
		else:
			animPlayer.play("idleRight")

func _on_detect_area_entered(area):
	target = area

func _on_chase_area_exited(area):
	target = null

### attack section ----------------------------------------------------------
func _on_attack_area_entered(area):
	inAtkRange = true

func _on_attack_area_exited(area):
	inAtkRange = false
	#reactionTimer.stop()

#attacks after timer runs out
func _on_reaction_timer_timeout():
	if !weapon || !target || !inAtkRange:
		return
	
	var vectorToTarget = target.global_position - pivot.global_position
	vectorToTarget = vectorToTarget.normalized()
	
	var attackVector = Vector2(roundi(vectorToTarget.x), roundi(vectorToTarget.y))
	var attackAngle = getAttackAngle(attackVector)
	
	var hDir = -1 if absf(vectorToTarget.x + 1) < absf(vectorToTarget.x - 1) \
		else 1 
	
	if hDir == -1: # left
		animPlayer.play("idleLeft")
		weapon.playAtkLeft() 
		pivot.rotation = deg_to_rad(attackAngle)
	else: #right
		animPlayer.play("idleRight")
		weapon.playAtkRight()
		pivot.rotation = deg_to_rad(-1 * attackAngle)

func _on_hurt_box_area_entered(area):
	fxAnimPlayer.play("hurtBlink");
	hp -= area.dmg
