extends Node2D

enum DMGTYPE {
	SLASH, #light/no armor
	BLUNT, #heavy/mid armor, higher stun time & knockback
	PIERCE #mid/light armor, higher crit chance, lower base dmg
}

@export var dmg: int #amt of standard dmg the weapon does
@export var spDmg: int #amt of spc dmg the weapon does against certain targets
@export var spType: DMGTYPE #type of special dmg
@export var stunTm: float #how long target gets stunned
@export var knBk: int #how much target gets knocked back

@onready var animPlayer = $AnimationPlayer
@onready var hitbox = $HitBox

var hitList = [] #keeps track of targets hit

func _ready():
	dmg = 10
	spDmg = 5
	spType = DMGTYPE.SLASH
	stunTm = 0.1
	knBk = 10
	
	hitbox.setAll(dmg, spDmg, spType, stunTm, knBk)

func _on_HitBox_area_entered(area):
	if !hitList.has(area):
		hitList.append(area)
		area.tkDmg(dmg,spDmg,spType,stunTm,knBk)
		

func getDmg(target):
	if hitList.has(target):
		return 0
	else:
		return dmg

func clearHitList():
	hitList.clear()

func playAnim():
	animPlayer.play("attack")

func updateKbDir(vector):
	hitbox.kbVector = vector.normalized()
