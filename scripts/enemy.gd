class_name Enemy
extends Control
## Script that handles the enemy attacks
## and adds status to effect

@export var death_particle: String = "blood"
@export var enemy_dying: AudioStream


@export var achievement_will_gain:String = ""

@export var id: int = 0

@export var attacks_name:Array[String] = []
@export var def_stats: int = 1
@export var setted_HP: float = 50
var current_attack_choice :int = -1
var attacks:Array[Dictionary] = []

var can_attack: bool = false
var damage_multiplier: float = 1
var playing_animation = false

func _ready() -> void:
	Events.connect("players_turn",allow_attack)
	for i in attacks_name:
		attacks.append(EnemyAttacks.get(i))
		

func allow_attack():
	playing_animation = false

# enemy attack script
# enemy attacks when attack_id == their id
func _attacked_player() -> void:
	playing_animation = true
	if current_attack_choice  >= attacks.size() -1:
		current_attack_choice = 0
	else:
		current_attack_choice += 1
	var sentence = ""
	
	var damage =(attacks[current_attack_choice].get("damage")) * damage_multiplier
	
	sentence = name+ " uses " + attacks[current_attack_choice].get("name")
	

	var all_effects = attacks[current_attack_choice]["status_effects"]
	for effect in all_effects: 
		Events.emit_signal("give_side_effects", effect)
	if attacks[current_attack_choice]["buff"] != null:
		var all_buffs = attacks[current_attack_choice]["buff"]
		for effect in all_buffs: 
			Events.give_side_effects_to_enemies.emit(effect)
	if get_tree() == null:
		return
	Events.emit_signal("update_display", sentence)
	Events.damaged_player.emit(damage, IngameStats.DamageAnim.HIT)

