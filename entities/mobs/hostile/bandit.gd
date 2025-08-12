extends "res://entities/Entity.gd"

const PARTICLE_BURST_SPARK = preload("res://fx/particle/particle_burst_sparks.tscn")

enum States {
	IDLE,
	WANDER,
	HURT,
	CHASE,
	ATTACK
}
#range of how long it takes for enemy to attack
@export var atkReactionLow = .5
@export var atkReactionHigh = .5

@onready var spriteBase = $base
@onready var animPlayer = $AnimPlayer
@onready var fxAnimPlayer = $fxAnimPlayer

@onready var shaker: = Shaker.new(spriteBase)
@onready var attackTimer = $attackTimer
@onready var pivot = $Pivot
@onready var weapon = $Pivot/Weapon
@onready var softCollision = $SoftCollision

var knockback = Vector2()
var target = null
var inAtkRange = false
var moveDir = Vector2.ZERO

func _ready():
	super()
	state = States.IDLE
	
	if weapon:
		weapon.connect("animFinished", finishedAtkAnim)

func _physics_process(delta):
	#state machine
	match state:
		States.IDLE:
			idleState()
		States.HURT:
			hurtState()
		States.CHASE:
			chaseState()
		States.ATTACK:
			attackState()

func idleState():
	playIdleAnim()
	if target:
		state = States.CHASE

func hurtState():
	pass

func chaseState():
	if target && inAtkRange:
		attackTimer.wait_time = randf_range(atkReactionLow, atkReactionHigh)
		attackTimer.start()
		
		state = States.ATTACK
	
	elif target && !inAtkRange:
		playMoveAnim()
		moveToTarget()
		
	else:
		moveDir = Vector2.ZERO
		state = States.IDLE

func moveToTarget():
	var vectorToTarget = target.global_position - pivot.global_position
	vectorToTarget = vectorToTarget.normalized()
	
	hDir = -1 if absf(vectorToTarget.x + 1) < absf(vectorToTarget.x - 1) \
		else 1 
		
	moveDir = target.global_position - global_position
	moveDir = moveDir.normalized()
	
	if softCollision.isColliding():
		moveDir += softCollision.getPushVector() * 1
	
	velocity = moveDir * spd
	move_and_slide()

func attackState():
	playIdleAnim()
	if !inAtkRange:
		state = States.CHASE
	
	velocity = velocity.move_toward(Vector2.ZERO, randf_range(FRICTION, FRICTION + 5))
	move_and_slide()

func finishedAtkAnim():
	state = States.IDLE

func playIdleAnim():
	if (hDir == -1): #face left
		animPlayer.play("idleLeft")
	else:
		animPlayer.play("idleRight")

func playMoveAnim():
	if (hDir == -1): #face left
		animPlayer.play("walkLeft")
	else: #face right
		animPlayer.play("walkRight")

func _on_detect_area_entered(area):
	target = area

func _on_chase_area_exited(area):
	target = null

### attack section ----------------------------------------------------------
func _on_attack_area_entered(area):
	inAtkRange = true

func _on_attack_area_exited(area):
	inAtkRange = false

#attacks after timer runs out
func _on_attack_timer_timeout():
	if !weapon || !target || !inAtkRange:
		return
	
	var vectorToTarget = target.global_position - pivot.global_position
	vectorToTarget = vectorToTarget.normalized()
	
	var attackVector = Vector2(roundi(vectorToTarget.x), roundi(vectorToTarget.y))
	var attackAngle = getAttackAngle(attackVector)
	
	hDir = -1 if absf(vectorToTarget.x + 1) < absf(vectorToTarget.x - 1) \
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
	var sparkParticle = PARTICLE_BURST_SPARK.instantiate()
	get_tree().current_scene.add_child(sparkParticle)
	sparkParticle.global_position = spriteBase.global_position
	
	fxAnimPlayer.play("hurtBlink");
	shaker.shake(2, 0.2)
	hp -= area.dmg


func _on_fx_anim_player_animation_finished(anim_name):
	if anim_name == "hurtBlink":
		if hp <= 0:
			queue_free()
