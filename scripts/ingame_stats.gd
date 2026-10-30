class_name IngameStats
extends Node2D

@onready var hp:ProgressBar = $HP
@onready var label:Label = $Label

## player in game stats

var HP: float

enum DamageAnim { HIT, RUST, BURN }

var enemy_thats_attacking: String

var damage_multiplier: float = 1
var damage_sfx: AudioStream = preload("res://sfx/player dmagae.mp3")

var incoming_damage: float = 0

@onready var battle:Battle = $"/root/battle"

@onready var animation_player = $"../animations"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HP.max_value = PlayerStats.player_hitpoint
	$HP.value = PlayerStats.player_hitpoint
	$Label.text = str(snapped($HP.value, 0.01)) + "/" +str(int($HP.max_value))
	Events.damaged_player.connect(_take_damage)

# plays enemy attack animations
func _on_animations_animation_finished() -> void:
	animation_player.visible = false
	$HP.value -= incoming_damage
	$Label.text = str(snapped($HP.value, 0.01)) + "/" +str(int($HP.max_value))
	
	if $HP.value<=0:
		get_tree().change_scene_to_file("res://scenes/deathScene.tscn")

# damage the player
func _take_damage(damage: float, damage_anim:DamageAnim) -> void:
	if damage == 0: return
	if battle.player_effects.get_value(EffectData.VULNERABILITY): damage *= 1.3
	if battle.player_effects.get_value(EffectData.RUST): damage /= 1.3
	damage -= battle.player_effects.get_value(EffectData.PARRY) * 2
	damage = max(ceil(damage), 0)
	AudioManager.play_oneshot(damage_sfx)
	incoming_damage = damage
	animation_player.visible = true
	match damage_anim:
		#DamageAnim.RUST: animation_player.play(&"rust")
		_: animation_player.play(&"no_animation")

func _heal(amount: float) -> void:
	$HP.value = min(amount, $HP.max_value)
	$Label.text = str(snapped($HP.value, 0.01)) + "/" +str(int($HP.max_value))

