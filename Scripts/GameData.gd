extends Node

var DEBUG_SPEED = 1.0/10.0
var RACE_STEPS = 1000
var STARTING_MONEY = 1000
var VARIANCE = true
var ANIMATION_SCALE = 0.5
var BET_STEP = 50
var MIN_BET = 50
var MAX_BET = 750
var HORSES_PER_RACE = 6
var IS_DEBUG = false
var PLANTED_ITEMS_PER_ROUND = 1000


func get_properties() -> Dictionary[String, String]:
	var properties = {
		"_LABEL" : "Main",
		"DEBUG_SPEED": DEBUG_SPEED,
		"RACE_STEPS": RACE_STEPS,
		"VARIANCE": VARIANCE,
		"STARTING_MONEY": STARTING_MONEY,
		"ANIMATION_SCALE": ANIMATION_SCALE
	}
	return properties

func update_property(name, value):
	set(name, value)
