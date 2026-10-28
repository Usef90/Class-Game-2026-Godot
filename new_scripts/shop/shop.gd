class_name Shop
extends Control

## shop scene thingy kallum coded this since I been on this to add cards I 
## kinda know how it wokrs

@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var top_fridge = $TopFridge        # Relics here
@onready var bottom_fridge = $BottomFridge  # Cards here
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll
@onready var next_stage_button = $MarginContainer/ActionMenu/NextStage

var reroll_cost: int = 2

func available_cards() -> Array[CardData]:
	var cards:Array[CardData] = []
	for card in CardData.CARDS:
		# if condition
		cards.append(card)
	return cards

func available_relics() -> Array[RelicData]:
	var relics:Array[RelicData] = []
	for relic in RelicData.RELICS:
		# if condition
		relics.append(relic)
	return relics


func _ready() -> void:
	AudioManager.play("LevelSelect")
	# Safe check to make sure upgrades array exists on PlayerStats Autoload
	if not "upgrades" in PlayerStats:
		PlayerStats.set("upgrades", [])

	update_gold_ui()
	
	next_stage_button.pressed.connect(_on_next_stage_pressed)
	reroll_button.pressed.connect(_on_reroll_pressed)
	
	clear_shop_shelves()
	generate_entire_shop()

func update_gold_ui() -> void:
	money_text.text = "$" + str(PlayerStats.player_gold)
	
	if PlayerStats.player_gold < reroll_cost:
		reroll_button.disabled = true
		reroll_button.text = "Reroll (HaHa Pooron!)"
	else:
		reroll_button.disabled = false
		reroll_button.text = "Reroll $" + str(reroll_cost)

func clear_shop_shelves() -> void:
	for child in top_fridge.get_children():
		child.queue_free()
	for child in bottom_fridge.get_children():
		child.queue_free()

func generate_entire_shop() -> void:
	var temp_relics_pool:Array[RelicData] = available_relics()
	var temp_cards_pool:Array[CardData] = available_cards()

	for i in range(2):
		if temp_relics_pool.is_empty(): break
		var relic:RelicData = temp_relics_pool.pick_random()
		create_relic_on_shelf(relic, top_fridge) 
		
	for i in range(5):
		if temp_cards_pool.is_empty(): break
		var card:CardData = temp_cards_pool.pick_random()
		print("here")
		create_card_on_shelf(card, bottom_fridge)

func create_card_on_shelf(card_data:CardData, target_fridge:Node) -> void:
	var card_node:ShopCard = ShopCard.create(card_data, self)
		
	target_fridge.add_child(card_node)

	# Hover tooltip -- Balatro-style popup instead of the native OS tooltip.
	HoverTooltip.setup(card_node, card_data.name, card_data.description)

func create_relic_on_shelf(relic_data:RelicData, target_fridge:Node) -> void:
	var relic_node:ShopRelic = ShopRelic.create(relic_data, self)
		
	target_fridge.add_child(relic_node)

	# Hover tooltip -- Balatro-style popup instead of the native OS tooltip.
	HoverTooltip.setup(relic_node, relic_data.name, relic_data.description)

func purchase_card(card:ShopCard) -> void:
	var data:CardData = card.card.data
	if PlayerStats.player_gold < data.price:
		print("Not enough money to buy ", data.name)
		return

	PlayerStats.player_gold -= data.price
	update_gold_ui()
	
	card.queue_free()
	
	PlayerStats.cards.append(data)
	print("Successfully Bought! Global Inventory Contents: ", PlayerStats.cards)

func _on_reroll_pressed() -> void:
	if PlayerStats.player_gold >= reroll_cost:
		PlayerStats.player_gold -= reroll_cost
		update_gold_ui()
		
		clear_shop_shelves()
		await get_tree().process_frame 
		generate_entire_shop()

func _on_next_stage_pressed() -> void:
	print("Transitioning to encounter with items: ", PlayerStats.cards)
	TransitionManager.play_transition("res://scenes/level_select.tscn")
