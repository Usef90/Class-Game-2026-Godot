class_name EffectData extends RefCounted

## displayed name of the effect
var name: String
## displayed description of the effect
var description: String
## if an effect is valueless then you either have it or you dont and it doesnt have a number
var valueless:bool = false
## whether or not an effect decreases by 1 at the end of your turn
var diminishes:bool = false

var icon:Texture2D

static var PARRY:EffectData = EffectData.new("Parry", "Reduces incoming damage by (x), lasts until end of enemy turn") \
	.with_icon(preload("res://Art/EFFECTSNEW/Parry_Effect.png"))
static var STRENGTH:EffectData = EffectData.new("Strength", "Increases damage by 2(x), lasts until end of combat") \
	.with_icon(preload("res://Art/EFFECTSNEW/Strength_Effect.png"))
static var TEMP_STRENGTH:EffectData = EffectData.new("Temporary Strength", "Increases damage by 2(x), lasts until end of your turn") \
	.with_icon(preload("res://Art/EFFECTSNEW/Strength_Effect.png"))
static var STRENGTH_MOMENTUM:EffectData = EffectData.new("Strength Momentum", "At end of enemy turn: gain (x) strength, lasts until end of combat") \
	.with_icon(preload("res://Art/EFFECTSNEW/Strength_Effect.png"))
static var BRACE:EffectData = EffectData.new("Brace", "Increases parry gained by 2(x), lasts until end of combat") \
	.with_icon(preload("res://Art/EFFECTSNEW/Brace_Effect.png"))
static var RUST:EffectData = EffectData.new("Rust", "Reduce incoming damage by 30%, at end of your turn: take 3 damage, reduce count by 1") \
			.with_diminishes().with_icon(preload("res://Art/EFFECTSNEW/Rust_Effect.png"))
static var BURN:EffectData = EffectData.new("Burn", "At end of your turn: take (x) damage, reduce count by 1") \
			.with_diminishes().with_icon(preload("res://Art/EFFECTSNEW/Burning_Effect.png"))
static var FORCEFIELD:EffectData = EffectData.new("Forcefield", "Parry is not removed at end of enemy turn") \
			.with_valueless().with_icon(preload("res://Art/EFFECTSNEW/Forcefield_Effect.png"))
static var DELAYED_PARRY:EffectData = EffectData.new("Delayed Parry", "At end of enemy turn: gain (x) parry, reduce count by (x)") \
	.with_icon(preload("res://Art/EFFECTSNEW/Parry_Effect.png"))
static var VULNERABILITY:EffectData = EffectData.new("Vulnerability", "Increases incoming damage by 30%") \
	.with_icon(preload("res://Art/EFFECTSNEW/Vulnerability_Effect.png"))

func _init(_name: String, _description:String) -> void:
	name = _name
	description = _description

func with_valueless() -> EffectData:
	valueless = true
	return self

func with_diminishes() -> EffectData:
	diminishes = true
	return self

func with_icon(_icon:Texture2D) -> EffectData:
	icon = _icon
	return self

