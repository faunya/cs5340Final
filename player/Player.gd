extends "res://entities/Entity.gd"

enum States {
	MOVE ,#able to move around
	DASH , 
	ATTACK,
	INTERACT
	}

#movement variables
var dashSpd = 300
var walkSpd = 150
var runSpd = 200

@onready var animPlayer = $AnimPlayer
@onready var shdwTm = $ShdwTm #timer for dropping "shadows" for pathfinding
@onready var weapon = $Pivot/Weapon

const shdwInst = preload("res://entities/ai/shdw.tscn")

var shdwList = []

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


func _physics_process(delta):
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
		setState("dash")
	
	#handles movement here
	if Input.is_action_pressed("sprint"):
		MAXSPD = runSpd
	else:
		MAXSPD = walkSpd
	
	var input = moveInput()
	
	if (input != Vector2.ZERO): #moving
		if input.x == -1:
			animPlayer.play("walkLeft")
		elif input.x == 1:
			animPlayer.play("walkRight")
		elif input.y == 1:
			animPlayer.play("walkDown")
		elif input.y == -1:
			animPlayer.play("walkUp")
		
	else: #idle
		if faceDir.x == -1:
			animPlayer.play("idleLeft")
		elif faceDir.x == 1:
			animPlayer.play("idleRight")
		elif faceDir.y == 1:
			animPlayer.play("idleDown")
		elif faceDir.y == -1:
			animPlayer.play("idleUp")
		
		
	movement(delta, input)
	
	#horizontal sprites only
	#if (input != Vector2.ZERO):
		#if (hDir == -1): #face left
			#animPlayer.play("walkLeft")
		#else: #face right
			#animPlayer.play("walkRight")
	#else:
		#if (hDir == -1): #face left
			#animPlayer.play("idleLeft")
		#else:
			#animPlayer.play("idleRight")

func attackState(delta):
	#movement(delta, Vector2())
	weapon.playAnim()
	
	FRICTION = 300
	stopMove(delta)
	FRICTION = 800
	match faceDir:
		Vector2(1,0):
			animPlayer.play("attackRight")
		Vector2(-1,0):
			animPlayer.play("attackLeft")
		Vector2(1,1):
			animPlayer.play("attackDownRight")
		Vector2(-1,1):
			animPlayer.play("attackDownLeft")
		Vector2(0,1):
			animPlayer.play("attackDown")
		Vector2(1,-1):
			animPlayer.play("attackUpRight")
		Vector2(-1,-1):
			animPlayer.play("attackUpLeft")
		Vector2(0,-1):
			animPlayer.play("attackUp")
	#move() #very jumpy

func dashState(delta):
	MAXSPD = dashSpd
	movement(delta, faceDir)
	MAXSPD = walkSpd
	setState("move")
	print(state)

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
		shdwTm.paused = false
		
	else:
		shdwTm.paused = true
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

#spawns shadow when timer times out
func _on_ShdwTm_timeout():
	var shdw = shdwInst.instantiate()
	shdwList.append(shdw)
	shdw.player = self
	shdw.position = global_position
	
	get_parent().add_child(shdw)
