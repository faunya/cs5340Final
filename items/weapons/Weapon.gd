extends Node2D

signal animFinished

enum DMGTYPE {
	SLASH, #light/no armor
	BLUNT, #heavy/mid armor, higher stun time & knockback
	PIERCE #mid/light armor, higher crit chance, lower base dmg
}

@export var dmg: int = 1 #amt of standard dmg the weapon does
@export var spDmg: int #amt of spc dmg the weapon does against certain targets
@export var spType: DMGTYPE #type of special dmg
@export var stunTm: float #how long target gets stunned
@export var knBk: int #how much target gets knocked back

@onready var animPlayer = $AnimationPlayer
@onready var hitbox = $HitBox

var hitList = [] #keeps track of targets hit

func _ready():
	hitbox.setAll(dmg, spDmg, spType, stunTm, knBk)

func getDmg(target):
	if hitList.has(target):
		return 0
	else:
		return dmg

func clearHitList():
	hitList.clear()

func updateKbDir(vector):
	hitbox.kbVector = vector.normalized()

func playAtkLeft():
	if animPlayer:
		animPlayer.play("attackLeft")

func playAtkRight():
	if animPlayer:
		animPlayer.play("attackRight")
		

func _on_animation_player_animation_finished(anim_name):
	emit_signal("animFinished")
