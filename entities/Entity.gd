extends CharacterBody2D

var state

#stats
@export var maxHp = 1
@export var hp = maxHp
@export var spd = 1

@export var MAXSPD = 150
@export var ACCELERATION = 1000
@export var FRICTION = 800

var mVel = Vector2()

var faceDir = Vector2(0,1) #Where the character is facing
var hDir = -1 #horizontal direction of char

#takes in Vector2 direction and moves the character in that direction at the
#given speed
func movement(delta, dir):	
	var direction = dir
	direction = direction.normalized()
	
	if dir != Vector2():
		mVel = mVel.move_toward(direction * MAXSPD, ACCELERATION * delta)
	else:
		mVel = mVel.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()

func stopMove(delta):
	mVel = mVel.move_toward(Vector2.ZERO, FRICTION * delta)
	move()

func move():
	set_velocity(mVel)
	move_and_slide()

func tkDmg(dmg, spcDmg, spcType):
	pass

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
