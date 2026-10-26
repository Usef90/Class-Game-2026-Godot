class_name PlayerEffects
extends Node

@onready var battle:Battle = $"/root/battle"

## status effect manager

var effect_types:Array[EffectData] = []
var effect_values:Array[int] = []

@onready var status_effect_viewer = $"../status_effect_viewer"
func _ready() -> void:
	Events.players_turn.connect(_players_turn)
	Events.enemies_turn.connect(_enemies_turn)
	Events.connect("give_side_effects_to_player", _new_side_effects)

# start of player turn
func _players_turn() -> void:
	for effect in len(effect_types):
		var effect_type:EffectData = effect_types[effect]
		match effect_type:
			EffectData.PARRY:
				if !EffectData.FORCEFIELD in effect_types:
					remove_effect(EffectData.PARRY)

# start of enemy turn
func _enemies_turn() -> void:
	for effect in len(effect_types):
		var effect_type:EffectData = effect_types[effect]
		var effect_value:int = effect_values[effect]
		match effect_type:
			EffectData.RUST:
				Events.damaged_player.emit(3, IngameStats.DamageAnim.RUST)
			EffectData.BURN:
				Events.damaged_player.emit(effect_value, IngameStats.DamageAnim.BURN)
		if effect_type.diminishes: _new_side_effects(effect_type, -1)

func remove_effect(effect:EffectData) -> void:
	var found:int = effect_types.find(effect)
	if found != -1:
		effect_types.remove_at(found)
		effect_values.remove_at(found)

func get_value(effect:EffectData) -> int:
	var found:int = effect_types.find(effect)
	return effect_values[found] if found != -1 else 0

func _new_side_effects(effect:EffectData, value:int) -> void:
	if effect == EffectData.PARRY: value += get_value(EffectData.BRACE) * 2

	var found:int = effect_types.find(effect)
	if found == -1:
		effect_types.append(effect)
		effect_values.append(0)
	effect_values[found] += value
	if effect_values[found] <= 0:
		effect_types.remove_at(found)
		effect_values.remove_at(found)

