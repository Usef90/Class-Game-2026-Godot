extends Node

## The script in the main battle scene. 
## Handles the state of the current battles
## Check the current victory conditions  and stuff

var current_turn: int = 0

var enemy_id_turn: int = 0
@export var music_name: String
@export var total_enemies:int = 1
@export var ending_of_story: bool = false
@export var victory_gold: int = 10
@export var achievement_will_gain:String = ""
const MAX_CARDS = 6

var num_enemies:int = 0
var current_state:States
enum States {PLAYER_TURN, ENEMY_TURN, DIALOGUE} 

var cards_can_spawn:Array[CardData] = []

@onready var ui:BattleUI = $"battle_ui"
@onready var player_stats:IngameStats = $"player/player_stats"

var victory: bool = false

var card_choice:CardData

func _ready() -> void:
	AudioManager.play(music_name)
	cards_can_spawn = PlayerStats.cards.duplicate()
	ui.cards.child_order_changed.connect(_update_card_ids)
	# giving enemies some unique ids
	for enemy in %enemies.get_children():
		enemy.id = num_enemies
		num_enemies += 1
	
	current_state = States.PLAYER_TURN
	ui.victory.hide()
	Events.players_turn.connect(_players_turn)
	Events.enemies_turn.connect(_enemies_turn)
	Events.dialogue.connect(_dialogue)
	Events.check_victory_conditions.connect(_check_victory)
	
	_players_turn()

func _dialogue():
	current_state = States.DIALOGUE

# player turn 
# removes the hand and just add 6 more new cards
# cards drawn are not random
func _players_turn():
	current_state = States.PLAYER_TURN
	current_turn += 1
	
	for i in ui.cards.get_children():
		i.queue_free()
	
	for i in range(MAX_CARDS):
		card_choice = cards_can_spawn.pop_at(randi_range(0, len(cards_can_spawn)-1))
		ui.cards.add_child(BattleCard.create(card_choice, i))
	
	player_stats.hp.value += PlayerStats.player_hitpoint_recovery
	get_parent().get_node("player").get_node("player_stats").get_node("Label").text = str(int(get_parent().get_node("player").get_node("player_stats").get_node("HP").value)) + "/" +str(int(get_parent().get_node("player").get_node("player_stats").get_node("HP").max_value))

# clean up the id of the cards
func _update_card_ids() -> void:
	var children = ui.cards.get_children()
	for index in range(children.size()):
		children[index].card_id = index

# enemy turn
# set the statemachine to the enemy's turn
func _enemies_turn():
	current_state = States.ENEMY_TURN

func _process(_delta: float) -> void:
	_check_victory()

func _check_victory():
	# check if zero enemies are in the scene and show the vicotry scene
	if %enemies.get_child_count() == 0 and !victory and !ending_of_story:
		Globals.achievements[achievement_will_gain] = true
		victory = true
		@warning_ignore("integer_division")
		victory_gold += int(PlayerStats.luck/5)
		PlayerStats.player_gold +=  victory_gold
		ui.victory.show()
		ui.victory.get_node("stuff you gain").text = "Gain: " + str(victory_gold) + " gold" + "
		Total gold: " + str(PlayerStats.player_gold)  
	elif %enemies.get_child_count()  == 0 and !victory and ending_of_story:
		Globals.achievements[achievement_will_gain] = true
		victory = true
		ui.ending.show()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
