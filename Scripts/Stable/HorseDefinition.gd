class_name HorseDefinition

const HORSE_COLORS = [
	Color(0.107022, 0.039546, 0.020289),
	Color(0.05448, 0.025187, 0.016807),
	Color(0.021219, 0.002732, 0.003035),
	Color(0.208636, 0.158961, 0.138432),
	Color.BLACK,
	Color.TOMATO,
	Color.SANDY_BROWN,
	Color.PERU,
	Color.LIGHT_SLATE_GRAY,
	Color.GAINSBORO
]

const MAINE_COLORS = [
	Color.BLACK,
	Color.NAVAJO_WHITE,
	Color.DIM_GRAY,
	Color.PERU,
	Color.SADDLE_BROWN,
	Color.LIGHT_SLATE_GRAY
]

const COVER_COLORS = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.REBECCA_PURPLE,
	Color.WHITE,
	Color.BLACK
]

var id : int = 0
var name : String = "HORSE"
var headSize : float = 1.0
var buttSize : float = 1.0
var torsoSize : float = 1.0
var snoutDroop : float = 1.0
var toothSize : float = 1.0
var neckSize : float = 1.0
var bellySize : float = 1.0
var color : Color = Color.hex(0x422C23)
var cover_color : Color = Color.WHITE
var maine_color : Color = Color.WHITE
var wins : int = 0
var losses : int = 0

func _init(id: int = 0, name : String = "HORSE", randomizeStats: bool = true):
	self.id = id
	self.name = name
	color = HORSE_COLORS.pick_random()
	cover_color = COVER_COLORS.pick_random()
	maine_color = MAINE_COLORS.pick_random()
	if(randomizeStats):
		headSize = randf_range(0,2)
		buttSize = randf_range(0,2)
		torsoSize = randf_range(0,2)
		snoutDroop = randf_range(0,2)
		toothSize = randf_range(0,2)
		neckSize = randf_range(0,2)
		bellySize = randf_range(0,2)
		pass
