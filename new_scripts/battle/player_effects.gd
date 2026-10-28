class_name PlayerEffects
extends Node

@onready var battle:Battle = $"/root/battle"

## status effect manager

var effect_types:Array[EffectData] = []
var effect_values:Array[int] = []
var effects_changed:bool = false

@onready var status_effect_viewer = $"../status_effect_viewer"
func _ready() -> void:
	Events.players_turn.connect(_players_turn)
	Events.enemies_turn.connect(_enemies_turn)
	Events.connect("give_side_effects_to_player", _new_side_effects)

func _process(_delta:float) -> void:
	if effects_changed:
		effects_changed = false
		for child in status_effect_viewer.get_children():
			status_effect_viewer.remove_child(child)
			child.queue_free()
		for effect in len(effect_types):
			var icon:StatusEffectIcon = preload("res://new_scenes/status_effect_icon.tscn").instantiate()
			icon.effect = effect_types[effect]
			icon.value = effect_values[effect]
			status_effect_viewer.add_child(icon)

# start of player turn
func _players_turn() -> void:
	# Array[EffectData, int (value)]
	var effect_changes:Array[Array] = []
	for effect in len(effect_types):
		var effect_type:EffectData = effect_types[effect]
		var effect_value:int = effect_values[effect]
		match effect_type:
			EffectData.PARRY:
				if !EffectData.FORCEFIELD in effect_types:
					effect_changes.append([EffectData.PARRY, -9999999999])
			EffectData.STRENGTH_MOMENTUM:
				effect_changes.append([EffectData.STRENGTH, effect_value])
			EffectData.DELAYED_PARRY:
				effect_changes.append([EffectData.PARRY, effect_value])
				effect_changes.append([EffectData.DELAYED_PARRY, -9999999999])
	for change in effect_changes: _new_side_effects(change[0], change[1])

# start of enemy turn
func _enemies_turn() -> void:
	# Array[EffectData, int (value)]
	var effect_changes:Array[Array] = []
	for effect in len(effect_types):
		var effect_type:EffectData = effect_types[effect]
		var effect_value:int = effect_values[effect]
		match effect_type:
			EffectData.RUST:
				Events.damaged_player.emit(3, IngameStats.DamageAnim.RUST)
			EffectData.BURN:
				Events.damaged_player.emit(effect_value, IngameStats.DamageAnim.BURN)
			EffectData.TEMP_STRENGTH:
				effect_changes.append([EffectData.TEMP_STRENGTH, -9999999999])
		if effect_type.diminishes: effect_changes.append([effect_type, -1])
	for change in effect_changes: _new_side_effects(change[0], change[1])

func get_value(effect:EffectData) -> int:
	var found:int = effect_types.find(effect)
	return effect_values[found] if found != -1 else 0

func _new_side_effects(effect:EffectData, value:int) -> void:
	if effect == EffectData.PARRY: value += get_value(EffectData.BRACE) * 2
	if value == 0: return
	effects_changed = true
	var found:int = effect_types.find(effect)
	if found == -1:
		effect_types.append(effect)
		effect_values.append(0)
	effect_values[found] += value
	if effect_values[found] <= 0:
		effect_types.remove_at(found)
		effect_values.remove_at(found)
