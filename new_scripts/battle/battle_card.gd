class_name BattleCard
extends Control

@onready var battle:Battle = $"/root/battle"

@onready var card:CardNode = $"card"

var data:CardData
var card_id:int

static func create(_data:CardData, _card_id:int) -> BattleCard:
	var node:BattleCard = preload("res://new_scenes/battle_card.tscn").instantiate()
	node.get_node("card").data = _data
	node.data = _data
	node.card_id = _card_id
	return node

var can_attack = false

var selected_card: bool = false
var mouse_is_incard: bool = false
var luck: int = 0

var card_number: int =0
const POSITION_OF_CARDS:Array = [
	Vector2(100,500),
	Vector2(250,500),
	Vector2(400,500),
	Vector2(550,500),
	Vector2(700,500),
	Vector2(850,500)
]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and !selected_card and get_global_rect().has_point(get_global_mouse_position()):
		selected_card = true
		
	if event.is_action_released("click") and selected_card and can_attack:
		var acted:bool = false
		match data.target:
			CardData.Target.ENEMY: acted = !!battle.hovered_enemy
			CardData.Target.ENEMIES: acted = battle.enemies_hovered
			CardData.Target.PLAYER: acted = battle.player_hovered
		if acted:
			act()
			queue_free()
		else: selected_card = false

func act() -> void:
	Events.emit_signal("reduce_energy_by", data.energy_cost)
	
	for repeat in data.repeats:
		var total_damage:int = data.damage
		if total_damage != 0:
			var strength:int = battle.player_effects.get_value(EffectData.STRENGTH) \
				+ battle.player_effects.get_value(EffectData.TEMP_STRENGTH)
			if data.id == CardData.TITAN_SMACK: total_damage += 6*strength
			else: total_damage += 2*strength
		
		match data.target:
			CardData.Target.ENEMY: Events.damaged_enemy.emit(total_damage, battle.hovered_enemy)
			CardData.Target.ENEMIES: Events.damaged_enemy.emit(total_damage, null)
		
		for effect in len(data.effect_types):
			var effect_type:EffectData = data.effect_types[effect]
			var effect_value:int = data.effect_values[effect]
			match data.effect_targets[effect]:
				CardData.Target.PLAYER:
					match data.id:
						CardData.ENRAGE:
							Events.give_side_effects_to_player.emit(effect_type, 2*battle.player_effects.get_value(EffectData.STRENGTH))
						_: Events.give_side_effects_to_player.emit(effect_type, effect_value)
				CardData.Target.ENEMY: Events.give_side_effects_to_enemies.emit(effect_type, effect_value, battle.hovered_enemy)
				CardData.Target.ENEMIES: Events.give_side_effects_to_enemies.emit(effect_type, effect_value, null)

func _process(_delta: float) -> void:
	# check if thee card is played in the play field
	if !selected_card:

		if card_id >= 0 and card_id < POSITION_OF_CARDS.size():
			position = POSITION_OF_CARDS[card_id]
		else:
			# makes the card go back to the original positions
			position = POSITION_OF_CARDS[clamp(card_id, 0, POSITION_OF_CARDS.size() - 1)]
	else:
		position = get_global_mouse_position() + Vector2(-100,-100)

func _ready() -> void:
	can_attack = true
	Events.connect("total_energy", _stop_fighting)
	Events.connect("players_turn", _can_attack)

# prevents the player to use the card when energy are gone
func _stop_fighting(total_energy):
	if total_energy < data.energy_cost:
		can_attack = false

func _can_attack():
	can_attack =  true

func _on_mouse_entered() -> void: mouse_is_incard = true
func _on_mouse_exited() -> void: mouse_is_incard = false

