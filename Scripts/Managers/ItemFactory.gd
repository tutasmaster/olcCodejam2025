extends Node
var items = [
	Item.new("CARROT", "Horses tend to sprint longer when they're not hungry.", 100, Item.EFFECT_TYPE.STAMINA, 50, true),
	Item.new("APPLE", "This fruit energizes the horse, letting it run faster.", 100, Item.EFFECT_TYPE.SPEED, 1, true),
	Item.new("DEVIL'S LETTUCE", "This vegetable allows the horse to burst into action.", 100, Item.EFFECT_TYPE.START_SPEED, 1, true),
	Item.new("JALAPENO", "The spiciness will make this horse more agressive.", 100, Item.EFFECT_TYPE.AGGRESSIVENESS, 1, true),
	Item.new("MILK", "It's neutralizing agent will calm down a horse.", 100, Item.EFFECT_TYPE.AGGRESSIVENESS, -1, true),
	Item.new("MYSTERY MEAT", "It's said to potentially change a horse's behaviour.", 100, Item.EFFECT_TYPE.RANDOMIZE_STRAT, 1, false),
	Item.new("BLUEBERRY", "It's blue.", 10, Item.EFFECT_TYPE.MAKE_BLUE, 1, false),
	Item.new("PINKBERRY", "It's pink.", 10, Item.EFFECT_TYPE.MAKE_PINK, 1, false),
]
