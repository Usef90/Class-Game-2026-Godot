class_name EffectData extends RefCounted

## displayed name of the effect
var name: String
## displayed description of the effect
var description: String
## if an effect is valueless then you either have it or you dont and it doesnt have a number
var valueless:bool = false
## whether or not an effect decreases by 1 at the end of your turn
var diminishes:bool = false

static var PARRY:EffectData = EffectData.new("Parry", "Reduces incoming damage by (x), lasts until end of enemy turn")
static var STRENGTH:EffectData = EffectData.new("Strength", "Increases damage by 2(x), lasts until end of combat")
static var TEMP_STRENGTH:EffectData = EffectData.new("Temporary Strength", "Increases damage by 2(x), lasts until end of your turn")
static var STRENGTH_MOMENTUM:EffectData = EffectData.new("Strength Momentum", "At start of your turn: gain (x) strength, lasts until end of combat")
static var BRACE:EffectData = EffectData.new("Brace", "Increases parry gained by 2(x), lasts until end of combat")
static var RUST:EffectData = EffectData.new("Rust", "Reduce incoming damage by 30%, at end of your turn: take 3 damage, reduce count by 1") \
			.with_diminishes()
static var BURN:EffectData = EffectData.new("Burn", "At end of your turn: take (x) damage, reduce count by 1") \
			.with_diminishes()
static var FORCEFIELD:EffectData = EffectData.new("Forcefield", "Parry is not removed at end of enemy turn") \
			.with_valueless()
static var DELAYED_PARRY:EffectData = EffectData.new("Delayed Parry", "At end of enemy turn: gain (x) parry, reduce count by (x)")
static var VULNERABILITY:EffectData = EffectData.new("Vulnerability", "Increases incoming damage by 30%")

func _init(_name: String, _description:String) -> void:
	name = _name
	description = _description

func with_valueless() -> EffectData:
	valueless = true
	return self

func with_diminishes() -> EffectData:
	diminishes = true
	return self

