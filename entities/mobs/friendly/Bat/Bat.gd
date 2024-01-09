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
@onready var lookFirst = $LookFirst
@onready var chase = $Chase

@onready var hurtBox = $HurtBox

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
	hp = 20
	state = States.IDLE
	spd = 150
	faceDir = Vector2()
	MAXSPD = 100
	ACCELERATION = 1000
	
	FRICTION = 300
#	thread = Thread.new()
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	
	if hp == 0:
		queue_free()
	
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
	seekTarget()

func wanderState():
	seekTarget()
	
func hurtState():
	pass
	
func chaseState(delta):
	if chase.target != null: #if in chase range
#		thread.start(self, "trackThread")
		trackTarget()
		
		if faceDir != Vector2():
			movement(delta, faceDir)
			
	#elif in attack range, attack state
	else:
		state = States.IDLE

func attackState():
	pass

#func trackThread(userdata):
#	while (true):
#		trackTarget()

func trackTarget():
	#print(faceDir)
	#raycasts to target
	lookLast.target_position = target.global_position - global_position
	lookLast.force_raycast_update()
	
	#if raycast doesn't collide, is open path and enemy faces that way
	if !lookLast.is_colliding():
		faceDir = lookLast.target_position.normalized()
	
#	else:
#		#goes through shdw list to see if any are visible
#		for shdw in target.shdwList:
#			#if shdw list is empty, ignore loop
#			if target.shdwList.size() == 0:
#				break
#
#			lookLast.cast_to = shdw.global_position - global_position
#			lookLast.force_raycast_update()
#
#			#if visible, path to shadow is open and entity faces to it
#			if !lookLast.is_colliding():
#				faceDir = lookLast.cast_to.normalized()
#				break
#
#			else:
#				#if no shdws are visble, stops moving
#				faceDir = Vector2()

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
