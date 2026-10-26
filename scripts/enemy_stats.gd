extends Node2D

## handles the enemy's hp

var HP: float
var speed:float

var damage_multiplier: float = 1

var def:float = 1
var player_damge_multiplier

@onready var battle:Battle = $"/root/battle"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = get_parent().setted_HP
	$HP.max_value = HP
	$HP.value = HP
	$Label.text = str(int($HP.value)) + "/" +str(int($HP.max_value))
	Events.damaged_enemy.connect(_take_damage)
	Events.connect("players_turn", _take_effect)

func _take_damage(damage: int, which:Enemy) -> void:
	if which != get_parent() and which != null: return
	player_damge_multiplier = battle.player_stats.damage_multiplier
	$HP.value -= damage * player_damge_multiplier * def * PlayerStats.player_damage * PlayerStats.player_aoe_damage
	$Label.text = str(snapped($HP.value, 0.01)) + "/" +str(int($HP.max_value))
	if $HP.value <= 0:
		# these were different for some reason so im keeping them different but we should probably change it
		if which == null:
			Explosions.spawn(get_parent().global_position, null, get_parent().death_particle)
		else:
			Explosions.spawn(get_parent().global_position)
			AudioManager.play_oneshot(get_parent().enemy_dying)
		get_parent().queue_free()
		Events.emit_signal("check_victory_conditions")


# called every turn
func _take_effect():
	if battle.current_state == Battle.States.DIALOGUE:
		return
	for i in $"../status".get_children():
		i._take_effect()
