class_name Battle
extends Node2D

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
@onready var player_stats:IngameStats = $"player/player_sprites/player_stats"
@onready var player_effects:PlayerEffects = $"player/player_sprites/player_effects"

var victory:bool = false

var hovered_enemy:Enemy = null
var player_hovered:bool = false
var enemies_hovered:bool = false

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
	
	_players_turn()

func _dialogue():
	current_state = States.DIALOGUE

# player turn 
# removes the hand and just add 6 more new cards
# cards drawn are not random
func _players_turn():
	var cards_pool:Array[CardData] = cards_can_spawn.duplicate()
	current_state = States.PLAYER_TURN
	current_turn += 1
	
	for i in ui.cards.get_children():
		i.queue_free()
	
	for i in range(MAX_CARDS):
		ui.cards.add_child(BattleCard.create(
			cards_pool.pop_at(randi_range(0, len(cards_pool)-1)), i
		))
	
	player_stats.label.text = str(int(player_stats.hp.value)) + "/" +str(int(player_stats.hp.max_value))

func exhaust(card:CardData) -> void:
	cards_can_spawn.erase(card)

# clean up the id of the cards
func _update_card_ids() -> void:
	var children = ui.cards.get_children()
	for index in range(children.size()):
		children[index].card_id = index

# enemy turn
# set the statemachine to the enemy's turn
func _enemies_turn():
	current_state = States.ENEMY_TURN
	for enemy:Enemy in %enemies.get_children():
		enemy._attacked_player()
		await get_tree().create_timer(0.4).timeout
	Events.emit_signal("players_turn")

func _process(_delta: float) -> void:
	_check_victory()
	var mouse_position:Vector2 = get_global_mouse_position()
	player_hovered = %player.get_global_rect().has_point(mouse_position)
	enemies_hovered = %enemies.get_global_rect().has_point(mouse_position)
	hovered_enemy = null
	for enemy in %enemies.get_children():
		if enemy.get_global_rect().has_point(mouse_position): hovered_enemy = enemy

func _check_victory():
	# check if zero enemies are in the scene and show the vicotry scene
	if %enemies.get_child_count() == 0 and !victory and !ending_of_story:
		Globals.achievements[achievement_will_gain] = true
		victory = true
		PlayerStats.player_gold += victory_gold
		ui.victory.show()
		ui.victory.get_node("stuff you gain").text = "Gain: " + str(victory_gold) + " gold" + "
		Total gold: " + str(PlayerStats.player_gold)  
	elif %enemies.get_child_count()  == 0 and !victory and ending_of_story:
		Globals.achievements[achievement_will_gain] = true
		victory = true
		ui.ending.show()
