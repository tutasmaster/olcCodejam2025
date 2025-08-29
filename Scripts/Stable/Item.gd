class_name Item

enum EFFECT_TYPE {
	NONE,
	SPEED,
	STAMINA,
	START_SPEED,
	AGGRESSIVENESS,
	RANDOMIZE_STRAT,
	MAKE_BLUE,
	MAKE_PINK
}

var name : String = "CARROT"
var description: String = "Description"
var price : int = 200
var type : EFFECT_TYPE = EFFECT_TYPE.NONE
var potency : int = 0
var isUsableByNPC : bool = true

func _init(name: String, description: String, price: int, type: EFFECT_TYPE, potency: int, isUsableByNPC: bool):
	self.name = name
	self.description = description
	self.price = price
	self.type = type
	self.potency = potency
	self.isUsableByNPC = isUsableByNPC
