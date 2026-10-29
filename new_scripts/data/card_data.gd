class_name CardData
extends RefCounted

static var CARDS:Array[CardData] = []

enum Target { PLAYER, ENEMY, ENEMIES }

# if you need to identify a card in code, add a const here like:
#const TITAN_SMACK:int = 10
# where the number is the id of the card
# should only be necessary if the card has a nonstandard effect
# or if you need to specifically refer to it for some reason
# starting cards:
const SLICE:int = 0
const SEAR:int = 5
const EXPAND:int = 6
const ARMS_UP:int = 19
# strength applies triply
const TITAN_SMACK:int = 10
# triples strength
const ENRAGE:int = 14
# triples enemy burn
const INCINERATE:int = 15

## numerical id to identify the card. equal to its index in the CardData.CARDS array
var id:int
## displayed name of the card
var name: String
## displayed description of the card
var description: String
# shop stuff:
## price in shop of the card
var price: int = 75
# battle stuff:
## amount of times the card triggers in battle
var repeats: int = 1
## the main target of the card in battle
var target: Target = Target.ENEMY
## the energy cost of the card in battle
var energy_cost: int
## the damage the card does to its target(s)
var damage: int = 0
## whether the card exhausts or not
var exhaust: bool = false
# all of these arrays should have the same length
var effect_types: Array[EffectData] = []
var effect_values: Array[int] = []
var effect_targets: Array[Target] = []
# display stuff:
## the image on the card
var image: Texture2D

static func initialise() -> void:
	# ONLY ADD NEW CARDS AT THE END
	new_card("Slice", 1, "Deal 5 damage") \
		.attack(5)
	new_card("Power-up Slash", 1, "Deal 5 damage, gain 3 strength") \
		.attack(5).with_player_effect(EffectData.STRENGTH, 3)
	new_card("Oxidise", 1, "Deal 5 damage, apply 3 rust") \
		.attack(5).with_effect(EffectData.RUST, 3)
	new_card("Tetanus", 1, "Apply 5 rust") \
		.attack().with_effect(EffectData.RUST, 5)
	new_card("Ignite", 1, "Apply 5 burn",) \
		.attack().with_effect(EffectData.BURN, 5)
	new_card("Sear", 1, "Deal 5 damage, apply 3 burn") \
		.attack(5).with_effect(EffectData.BURN, 3)
	new_card("Expand", 0, "Gain 5 temporary strength") \
		.target_player().with_effect(EffectData.TEMP_STRENGTH, 5)
	new_card("Uppercut", 1, "Deal 7 damage, apply 1 strength") \
		.attack(7).with_player_effect(EffectData.STRENGTH, 1)
	new_card("Strength", 3, "Gain 3 strength-velocity") \
		.target_player().with_effect(EffectData.STRENGTH_MOMENTUM, 3)
	new_card("Barrage", 1, "Deal 3 damage 5 times") \
		.attack(3).with_repeats(5)
	new_card("Titan Smack", 2, "Deal 15 damage. Strength is tripled for this card") \
		.attack(15)
	new_card("Burning Chain", 2, "Deal 8 damage and apply 3 burn to all enemies") \
		.attack_aoe(8).with_effect(EffectData.BURN, 3)
	new_card("Hammering Slam", 1, "Deal 3 damage to all enemies 4 times") \
		.attack_aoe(3).with_repeats(4)
	new_card("Smash", 3, "Deal 25 damage, apply 3 burn, and lose 3 strength") \
		.attack(25).with_effect(EffectData.BURN, 3).with_player_effect(EffectData.STRENGTH, -3)
	new_card("Enrage", 3, "Triple your strength. Exhaust") \
		.target_player().with_effect(EffectData.STRENGTH)
	new_card("Incinerate", 3, "Triple the enemy's burn. Exhaust") \
		.attack().with_effect(EffectData.BURN)
	new_card("Overheat", 1, "Apply 4 burn to all enemies, and lose all parry") \
		.attack_aoe().with_effect(EffectData.BURN, 4).with_player_effect(EffectData.PARRY, -1000000)
	new_card("Reinforce", 2, "Gain 9 parry") \
		.target_player().with_effect(EffectData.PARRY, 9)
	new_card("Forcefield", 3, "Gain 5 parry, gain forcefield") \
		.target_player().with_effect(EffectData.FORCEFIELD)
	new_card("Arms Up", 1, "Gain 5 parry, gain 1 brace") \
		.target_player().with_effect(EffectData.PARRY, 5).with_effect(EffectData.BRACE, 1)
	new_card("Recharge", 1, "Gain 4 parry, gain 4 more parry at the start of your next turn") \
		.target_player().with_effect(EffectData.PARRY, 4).with_effect(EffectData.DELAYED_PARRY, 4)

static func new_card(_name:String, _energy_cost:int, _description: String) -> CardData:
	var card:CardData = CardData.new()
	card.id = len(CARDS)
	card.name = _name
	card.energy_cost = _energy_cost
	card.description = _description
	CARDS.append(card)
	return card

#func shop(_price:int) -> CardData: price = _price; return self

func target_player() -> CardData:
	target = Target.PLAYER
	return self
func attack(_damage:int=0) -> CardData:
	damage = _damage
	target = Target.ENEMY
	return self
func attack_aoe(_damage:int=0) -> CardData:
	target = Target.ENEMIES
	damage = _damage
	return self

func with_effect(effect:EffectData, value:int=0) -> CardData:
	effect_types.append(effect)
	effect_values.append(value)
	effect_targets.append(target)
	return self
func with_player_effect(effect:EffectData, value:int=0) -> CardData:
	effect_types.append(effect)
	effect_values.append(value)
	effect_targets.append(Target.PLAYER)
	return self

 
func repeat(_repeats:int) -> CardData: repeats = _repeats; return self
func with_repeats(_repeats:int) -> CardData: repeats = _repeats; return self

func with_exhaust() -> CardData: exhaust = true; return self
