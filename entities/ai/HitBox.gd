extends Area2D

var kbVector = Vector2.ZERO
var dmg #amt of standard dmg the weapon does
var spDmg #amt of spc dmg the weapon does against certain targets
var spType #type of special dmg
var stunTm #how long target gets stunned
var knBk #how much target gets knocked back

func setDmg(val):
	dmg = val

func setSpDmg(val):
	spDmg = val

func setSpType(val):
	spType = val

func setStunTm(val):
	stunTm = val

func setKnBk(val):
	knBk = val

func setAll(nDmg, nSpDmg, nSpType, nStunTm, nKnBk):
	setDmg(nDmg)
	setSpDmg(nSpDmg)
	setSpType(nSpType)
	setStunTm(nStunTm)
	setKnBk(nKnBk)
