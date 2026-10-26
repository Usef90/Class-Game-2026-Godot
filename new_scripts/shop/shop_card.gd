class_name ShopCard
extends Control

@onready var card:CardNode = $"card"
var shop:Shop
@onready var buy_button:Button = $"buy_button"

static func create(data:CardData, _shop:Shop) -> ShopCard:
	var node:ShopCard = preload("res://new_scenes/shop_card.tscn").instantiate()
	node.get_node("card").data = data
	node.shop = _shop
	return node

func _ready() -> void:
	buy_button.pressed.connect(func(): shop.purchase_card(self))
	buy_button.text = "$"+str(card.data.price)

