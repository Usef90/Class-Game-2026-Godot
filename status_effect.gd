extends Node

@onready var battle:Battle = $"/root/battle"

## status effect manager

var effect = []
@onready var status_effect_viewer = $"../status_effect_viewer"
func _ready() -> void:
	Events.connect("players_turn", _take_side_effects)
	Events.connect("give_side_effects_to_player", _new_side_effects)
	
	
func _take_side_effects():
	if battle.current_state == Battle.States.DIALOGUE:
		return
	for i in get_children():
		i._take_effect()
	
func _new_side_effects(effect:EffectData, value:int):
	# todo!
	pass
	#var new_effect =ListOfStatusEffects.get(effects).instantiate()
	#new_effect.player_ingame_stats = get_parent().get_parent().find_child("player_stats")
	
	#add_child(new_effect,true)
