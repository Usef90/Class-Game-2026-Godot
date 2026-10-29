class_name Effect extends RefCounted

# if an effect is valueless then you either have it or you dont and it doesnt have a number
var valueless:bool = false

static var PARRY:Effect = Effect.new()
static var STRENGTH:Effect = Effect.new()
static var TEMP_STRENGTH:Effect = Effect.new()
static var STRENGTH_MOMENTUM:Effect = Effect.new()
static var BRACE:Effect = Effect.new()
static var RUST:Effect = Effect.new()
static var BURN:Effect = Effect.new()
static var VULNERABLE:Effect = Effect.new()
static var FORCEFIELD:Effect = Effect.new().with_valueless()
static var DELAYED_PARRY:Effect = Effect.new()

func with_valueless() -> Effect:
	valueless = true
	return self
