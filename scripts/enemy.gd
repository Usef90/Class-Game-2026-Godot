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
var current_attack_choice :int = -1
var attacks:Array[Dictionary] = []

var can_attack: bool = false
var playing_animation = false

var damage: int = 6
var buffed_last_turn:bool = false
var debuffed_last_turn:bool = false
enum Choices { ATTACK, BUFF, DEBUFF }

func _ready() -> void:
	Events.connect("players_turn",allow_attack)
	for i in attacks_name:
		attacks.append(EnemyAttacks.get(i))

func allow_attack():
	playing_animation = false

func _attacked_player() -> void:
	if get_tree() == null: return
	
	var choices:Array[Choices] = [Choices.ATTACK, Choices.ATTACK]
	if !buffed_last_turn: choices.append(Choices.BUFF)
	if !debuffed_last_turn: choices.append(Choices.DEBUFF)
	
	var sentence = name
	
	match choices.pick_random():
		Choices.ATTACK:
			sentence += " attacks"
			Events.damaged_player.emit(damage, IngameStats.DamageAnim.HIT)
			damage += 3
		Choices.BUFF:
			sentence += " buffs itself"
			Events.give_side_effects_to_enemies.emit(EffectData.STRENGTH, 3, self)
		Choices.DEBUFF:
			sentence += " debuffs you"
			var debuff:EffectData = [EffectData.RUST, EffectData.BURN, EffectData.VULNERABILITY].pick_random()
			Events.give_side_effects_to_player.emit(debuff, 3)
	
	playing_animation = true
	Events.emit_signal("update_display", sentence)

