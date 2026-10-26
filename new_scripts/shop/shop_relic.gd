class_name ShopRelic
extends Control

@onready var relic:RelicNode = $"relic"
var shop:Shop
@onready var buy_button:Button = $"buy_button"

static func create(data:RelicData, _shop:Shop) -> ShopRelic:
	var node:ShopRelic = preload("res://new_scenes/shop_relic.tscn").instantiate()
	node.get_node("relic").data = data
	node.shop = _shop
	return node

func _ready() -> void:
	buy_button.pressed.connect(func(): shop.purchase_relic(self))
	buy_button.text = "$"+str(relic.data.price)

