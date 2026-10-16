class_name Card
extends RefCounted

static var CARDS:Array[Card] = []

var id:int
var name: String
var description: String
# shop stuff:
var price: int = 75
# battle stuff:
var repeats: int = 1
enum Target { PLAYER, ENEMY, ENEMIES }
var target: Target = Target.ENEMY
var energy_cost: int
var damage: int = 0
# all of these arrays should have the same length
var effect_types: Array[Effect] = []
var effect_values: Array[int] = []
var effect_targets: Array[Target] = []

func _ready() -> void:
	new_card("Slice", 1, "Deal 5 damage") \
		.attack(5)
	new_card("Power-up Slash", 2, "Deal 5 damage, apply 3 strength") \
		.attack(5).with_player_effect(Effect.STRENGTH, 3)
	new_card("Oxidise", 1, "Deal 5 damage, apply 3 rust") \
		.attack(5).with_effect(Effect.RUST, 3)
	new_card("Tetanus", 1, "Apply 5 rust") \
		.attack().with_effect(Effect.RUST, 5)
	new_card("Ignite", 1, "Apply 5 burn",) \
		.attack().with_effect(Effect.BURN, 5)
	new_card("Sear", 1, "Deal 5 damage, apply 3 burn") \
		.attack(5).with_effect(Effect.BURN, 3)
	new_card("Expand", 0, "Gain 5 temporary strength") \
		.target_player().with_effect(Effect.TEMP_STRENGTH, 5)
	new_card("Uppercut", 1, "Deal 7 damage, apply 1 strength") \
		.attack(7).with_player_effect(Effect.STRENGTH, 1)
	new_card("Strength", 3, "Gain 3 strength-velocity") \
		.target_player().with_effect(Effect.STRENGTH_MOMENTUM, 3)
	new_card("Barrage", 1, "Deal 3 damage 5 times") \
		.attack(3).repeat(5)
	new_card("Titan Smack", 2, "Deal 15 damage. Strength is tripled for this card") \
		.attack(15)
	new_card("Burning Chain", 2, "Deal 8 damage and apply 3 burn to all enemies") \
		.attack_aoe(8).with_effect(Effect.BURN, 3)
	new_card("Hammering Slam", 1, "Deal 3 damage to all enemies 4 times") \
		.attack_aoe(3).repeat(4)
	new_card("Smash", 3, "Deal 25 damage, apply 3 burn, and lose 3 strength") \
		.attack(25).with_effect(Effect.BURN, 3).with_player_effect(Effect.STRENGTH, -3)
	new_card("Enrage", 3, "Triple your strength. Exhaust") \
		.target_player().with_effect(Effect.STRENGTH)
	new_card("Incinerate", 3, "Triple the enemy's burn. Exhaust") \
		.attack().with_effect(Effect.BURN)
	new_card("Overheat", 1, "Apply 4 burn and 2 vulnerable to all enemies") \
		.attack_aoe().with_effect(Effect.BURN, 4).with_effect(Effect.VULNERABLE, 2)
	new_card("Reinforce", 2, "Gain 9 parry") \
		.target_player().with_effect(Effect.PARRY, 9)
	new_card("Forcefield", 3, "Gain forcefield") \
		.target_player().with_effect(Effect.FORCEFIELD)
	new_card("Arms Up", 1, "Gain 5 parry, gain 1 brace") \
		.target_player().with_effect(Effect.PARRY, 5).with_effect(Effect.BRACE, 1)
	new_card("Recharge", 1, "Gain 4 parry, gain 4 more parry at the start of your next turn") \
		.target_player().with_effect(Effect.PARRY, 4).with_effect(Effect.DELAYED_PARRY, 4)

static func new_card(_name:String, _energy_cost:int, _description: String) -> Card:
	var card:Card = Card.new()
	card.id = len(CARDS)
	card.name = _name
	card.energy_cost = _energy_cost
	card.description = _description
	CARDS.append(card)
	return card

#func shop(_price:int) -> Card: price = _price; return self

func target_player() -> Card:
	target = Target.PLAYER
	return self
func attack(_damage:int=0) -> Card:
	damage = _damage
	target = Target.ENEMY
	return self
func attack_aoe(_damage:int=0) -> Card:
	target = Target.ENEMIES
	damage = _damage
	return self

func with_effect(effect:Effect, value:int=0) -> Card:
	effect_types.append(effect)
	effect_values.append(value)
	effect_targets.append(target)
	return self
func with_player_effect(effect:Effect, value:int=0) -> Card:
	effect_types.append(effect)
	effect_values.append(value)
	effect_targets.append(Target.PLAYER)
	return self

func repeat(_repeats:int) -> Card: repeats = _repeats; return self


