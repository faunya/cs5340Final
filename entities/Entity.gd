extends CharacterBody2D

var state

@export_category("Stats")
@export var maxHp = 1
@export var hp = maxHp
@export var spd = 1

@export var FRICTION = 800

@export_category("Visuals")
@export var spriteFaceRight = false

var mVel = Vector2()

var faceDir = Vector2(0,1) #Where the character is facing
var hDir = -1 #horizontal direction of char

func _ready():
	if spriteFaceRight:
		hDir = 1

#takes in Vector2 direction and moves the character in that direction at the
#given speed
func movement(delta, dir):	
	var direction = dir
	direction = direction.normalized()
	
	if dir != Vector2():
		velocity = direction * spd
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

func stopMove(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
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
