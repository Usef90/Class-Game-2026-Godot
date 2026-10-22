class_name BattleCard
extends Control

@onready var card:CardNode = $"card"
var card_id:int

static func create(data:CardData, _card_id:int) -> BattleCard:
	var node:BattleCard = preload("res://new_scenes/battle_card.tscn").instantiate()
	node.get_node("card").data = data
	node.card_id = _card_id
	return node

