class_name UI
extends Control

@onready var HORSE_SELECTION = $HORSE_SELECTION_UI
var HORSE_PICKED : Node3D
var betting_enabled = false
var current_bet = 100

var selected_horse = 0

func show_horse_selection():
	betting_enabled = true
	pick_horse(0)
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
	$HORSE_SELECTION_UI/VBoxContainer/VBoxContainer/CURRENCY.text = "You currently have: " + str(Game.player.money) + "G"
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
