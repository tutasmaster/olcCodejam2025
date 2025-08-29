class_name UI
extends Control

@onready var HORSE_SELECTION = $HORSE_SELECTION_UI
var item_button_prefab = preload("res://Scenes/UI/ItemButton.tscn")
var HORSE_PICKED : Node3D
var betting_enabled = false
var current_bet = 100

var ICONS = {
	"APPLE" : preload("res://Assets/Sprites/Items/APPLE.png"),
	"BLUEBERRY" : preload("res://Assets/Sprites/Items/BLUE_BERRY.png"),
	"CARROT" : preload("res://Assets/Sprites/Items/CARROT.png"),
	"MYSTERY MEAT" : preload("res://Assets/Sprites/Items/MEAT.png"),
	"PINKBERRY" : preload("res://Assets/Sprites/Items/PINK_BERRY.png"),
	"UNKNOWN" : preload("res://Assets/Sprites/Items/UNKNOWN.png"),
}

var selected_horse = 0

var selected_item : Item = null

func _ready():
	for item in ItemFactory.items:
		var button : Button = item_button_prefab.instantiate()
		button.item = item
		button.pressed.connect(_on_item_pressed.bind(item))
		button.icon = ICONS.get(item.name, ICONS["UNKNOWN"])
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/GridContainer.add_child(button)
	_on_show_stats_pressed()

func show_horse_selection():
	betting_enabled = true
	pick_horse(selected_horse)
	$HORSE_SELECTION_UI.show()
	
func pick_horse(id):
	var horse = Game.race.horses[id]
	var horseDef = HorseFactory.getDefinitionFromID(horse.id)
	HORSE_PICKED.apply_model(Game.race.horses[id].id)
	$HORSE_SELECTION_UI/Label.text = Game.race.horses[id].name
	var start = "This horse has the following stats:\n\n"
	var wins = "Wins:" + str(horseDef.wins) + "\n"
	var losses = "Losses:" + str(horseDef.losses) + "\n"
	$HORSE_SELECTION_UI/VBoxContainer/PanelContainer/Label.text = start + wins + losses
	$HORSE_SELECTION_UI/CURRENCY.text = "You currently have: " + str(Game.player.money) + "G"
	selectBet(0)

func hide_horse_selection():
	betting_enabled = false
	$HORSE_SELECTION_UI.hide()

func bet():
	if(betting_enabled):
		Game.player.bets[Game.race.horses[selected_horse].id] = current_bet
		Game.player.money -= current_bet
		selectBet(0)
		get_parent().startTransition()
		betting_enabled = false

func _on_bet_pressed() -> void:
	bet()

func select(offset : int):
	selected_horse += offset
	if(selected_horse < 0):
		selected_horse = 5
	if(selected_horse > 5):
		selected_horse = 0
	pick_horse(selected_horse)

func _on_previous_pressed() -> void:
	select(-1)


func _on_next_pressed() -> void:
	select(+1)

func selectBet(offset : int):
	current_bet += offset
	current_bet = clamp(current_bet, GameData.MIN_BET, min(Game.player.money, GameData.MAX_BET))
	$HORSE_SELECTION_UI/VBoxContainer/VBoxContainer/HBoxContainer/Label.text = str(current_bet) + "G"
	
	
func _on_decrease_bet_pressed() -> void:
	selectBet(-GameData.BET_STEP)


func _on_increase_bet_pressed() -> void:
	selectBet(GameData.BET_STEP)


func _on_show_stats_pressed() -> void:
	$HORSE_SELECTION_UI/VBoxContainer/PanelContainer.show()
	$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2.hide()
	$HORSE_SELECTION_UI/VBoxContainer/HBoxContainer2.show()
	$HORSE_SELECTION_UI/VBoxContainer/VBoxContainer.show()
	


func _on_show_food_pressed() -> void:
	$HORSE_SELECTION_UI/VBoxContainer/PanelContainer.hide()
	$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2.show()
	$HORSE_SELECTION_UI/VBoxContainer/HBoxContainer2.hide()
	$HORSE_SELECTION_UI/VBoxContainer/VBoxContainer.hide()
	selected_item = null
	updateItem()

func updateItem():
	if(selected_item == null):
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label3.hide()
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label.hide()
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label2.hide()
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/CustomButton.disable()
	else:
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label3.show()
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label.show()
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label2.show()
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label3.text = selected_item.name
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label.text = selected_item.description
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/Label2.text = str(selected_item.price) + "G"
		$HORSE_SELECTION_UI/VBoxContainer/PanelContainer2/VBoxContainer/CustomButton.enable()
		
func _on_item_pressed(item):
	selected_item = item
	updateItem()

func _on_feed_pressed() -> void:
	if(Game.player.money < selected_item.price):
		return
	Game.player.money -= selected_item.price
	HorseFactory.apply_effect(selected_item, Game.race.horses[selected_horse].id)
	Game.race._onDefinitionUpdate()
	pick_horse(selected_horse)
