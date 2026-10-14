class_name Card
extends RefCounted

static var CARDS:Array[Card] = []

var id:int
var name: String
# shop stuff:
var shop_price: int = 75
var description: String
# in game:
enum Targets { PLAYER, ENEMY, ENEMIES }
var damage_target: Targets = Targets.ENEMY
var energy_cost: int
var damage: int
var effect_target: Targets = Targets.PLAYER
var effects: Array[Effect]

static func new_card(data:Dictionary) -> void:
	var card:Card = Card.new()
	card.id = len(CARDS)
	for element in data:
		card[element] = data[element]
	CARDS.append(card)

func _ready() -> void:
	new_card({
		name: "Slice",
		description: "Deal 5 damage",
		energy_cost: 1, damage: 5,
	})
	new_card({
		name: "Power-up Slash",
		description: "Deal 5 damage, apply 3 strength",
		energy_cost: 2, damage: 5,
		effects: [Effect.STRENGTH]
	})

