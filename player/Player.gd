extends "res://entities/Entity.gd"

enum States {
	MOVE ,#able to move around
	DASH , 
	ATTACK,
	INTERACT
	}

#movement variables
var walkSpd = 150
var runSpd = 200
var dashSpd = 300

var tween: Tween
var dashVelocity = 0.0
var dashDuration = 0.6

@onready var spriteBase = $base
@onready var animPlayer = $AnimPlayer
@onready var fxAnimPlayer = $fxAnimPlayer

@onready var shaker: = Shaker.new(spriteBase)

@onready var weapon = $Pivot/Weapon
@onready var pivot = $Pivot

@onready var dashTmr = $dashTimer
@onready var hurtbox = $HurtBox/CollisionShape2D

##stats
#var maxHp
#var hp
#var spd
#
#var MAXSPD
#var ACCELERATION
#var FRICTION
func _ready():
	spd = walkSpd
	state = States.MOVE
	
	FRICTION = 800
	ACCELERATION = 1000
	MAXSPD = walkSpd
	
	if weapon:
		weapon.connect("animFinished", finishedAtkAnim)


func _physics_process(delta):
	if hp <= 0:
		pass#queue_free()
	
	#state machine
	match state:
		States.MOVE:
			moveState(delta)
		States.DASH:
			dashState(delta)
		States.ATTACK:
			attackState(delta)
		States.INTERACT:
			pass

func moveState(delta):
	#state change
	if (Input.is_action_just_pressed("attack")):
		setState("attack")
	elif (Input.is_action_just_pressed("dash")):
		dashTmr.start()
		setState("dash")
	
	#handles movement here
	if Input.is_action_pressed("sprint"):
		MAXSPD = runSpd
	else:
		MAXSPD = walkSpd
	
	var input = moveInput()
		
	movement(delta, input)
	
	#horizontal sprites only
	if (input != Vector2.ZERO):
		if (hDir == -1): #face left
			animPlayer.play("walkLeft")
		else: #face right
			animPlayer.play("walkRight")
	else:
		if (hDir == -1): #face left
			animPlayer.play("idleLeft")
		else:
			animPlayer.play("idleRight")

func attackState(delta):
	FRICTION = 300
	stopMove(delta)
	FRICTION = 800
	
	var attackAngle = getAttackAngle(faceDir)
	
	if hDir == -1: # left
		animPlayer.play("idleLeft")
		weapon.playAtkLeft() 
		pivot.rotation = deg_to_rad(attackAngle)
	else: #right
		animPlayer.play("idleRight")
		weapon.playAtkRight()
		pivot.rotation = deg_to_rad(-1 * attackAngle)

func dashState(delta):
	print("dash")
	#hurtbox.disabled = true
	velocity = faceDir  * dashSpd
	velocity = velocity.normalized() * dashSpd
	move_and_slide()
	#setState("move")

func interactState():
	pass

#reads input from movement keys
func moveInput():
	var direction = Vector2()
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		hDir = 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		hDir = -1
	
	if (direction != Vector2()):
		faceDir = direction
		weapon.updateKbDir(direction)
	return direction

#sets to the given state
func setState(nextState):
	match nextState:
		"move":
			state = States.MOVE
		"attack":
			state = States.ATTACK
		"dash":
			state = States.DASH

func _on_hurt_box_area_entered(area):
	if state == States.DASH:
		return
		
	shaker.shake(2, 0.2)
	fxAnimPlayer.play("hurtBlink");
	hp -= area.dmg
	UiSignals.hpUpdated.emit(hp)


func _on_dash_timer_timeout():
	print("done")
	setState("move")

func finishedAtkAnim():
	setState("move")
