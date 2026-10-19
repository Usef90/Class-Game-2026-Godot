class_name EffectData extends RefCounted

# if an effect is valueless then you either have it or you dont and it doesnt have a number
var valueless:bool = false

static var PARRY:EffectData = EffectData.new()
static var STRENGTH:EffectData = EffectData.new()
static var TEMP_STRENGTH:EffectData = EffectData.new()
static var STRENGTH_MOMENTUM:EffectData = EffectData.new()
static var BRACE:EffectData = EffectData.new()
static var RUST:EffectData = EffectData.new()
static var BURN:EffectData = EffectData.new()
static var VULNERABLE:EffectData = EffectData.new()
static var FORCEFIELD:EffectData = EffectData.new().with_valueless()
static var DELAYED_PARRY:EffectData = EffectData.new()

func with_valueless() -> EffectData:
	valueless = true
	return self

