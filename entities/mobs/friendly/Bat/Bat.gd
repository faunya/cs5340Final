extends "res://entities/Entity.gd"

enum States {
	IDLE,
	WANDER,
	HURT,
	CHASE,
	ATTACK
}

var thread

@onready var detect = $Detect
@onready var lookLast = $LookLast
@onready var chase = $Chase

@onready var hurtBox = $HurtBox
@onready var hitBox = $HitBox
@onready var softCollision = $SoftCollision

@onready var animPlay = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var dmg = 1

var target = null
var targets = []

var knockback = Vector2()

#stats
#var maxHp
#var hp
#var spd
#
#var MAXSPD
#var ACCELERATION
#var FRICTION
func _ready():
	state = States.IDLE
	faceDir = Vector2()
#	thread = Thread.new()
	hitBox.setDmg(dmg)
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	
	if hp == 0:
		queue_free()
	
	if faceDir.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	#state machine
	match state:
		States.IDLE:
			idleState()
		States.WANDER:
			wanderState()
		States.HURT:
			hurtState()
		States.CHASE:
			chaseState(delta)
		States.ATTACK:
			attackState()

#states
func idleState():
	animPlay.play("idle")
	seekTarget()

func wanderState():
	seekTarget()
	
func hurtState():
	pass
	
func chaseState(delta):
	if chase.target != null: #if in chase range
		trackTarget()
		
		if softCollision.isColliding():
			faceDir += softCollision.getPushVector() * delta * 400
		
		if faceDir != Vector2():
			movement(delta, faceDir)
			
	#elif in attack range, attack state
	else:
		state = States.IDLE

func attackState():
	pass


func trackTarget():
	#raycasts to target
	lookLast.target_position = target.global_position - global_position
	lookLast.force_raycast_update()
	
	#if raycast doesn't collide, is open path and enemy faces that way
	if !lookLast.is_colliding():
		faceDir = lookLast.target_position.normalized()

func seekTarget():
	if detect.target != null:
		target = detect.target
		lookLast.target_position = target.global_position - global_position
		lookLast.force_raycast_update()
		state = States.CHASE
	else:
		state = States.IDLE

#
#func _exit_tree():
#	thread.wait_to_finish()


func _on_HurtBox_area_entered(area):
	knockback = area.kbVector * 250
	hp -= area.dmg
	print(hp)
	#knockback = knockback.normalized()
