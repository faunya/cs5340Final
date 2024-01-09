extends CharacterBody2D

var state

#stats
var maxHp
var hp
var spd

var MAXSPD
var ACCELERATION
var FRICTION

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
