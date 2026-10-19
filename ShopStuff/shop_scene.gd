class_name Shop
extends Control

## shop scene thingy kallum coded this since I been on this to add cards I 
## kinda know how it wokrs

@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")
@export var pack_scene: PackedScene = preload("res://Upgrades/upgrade_pack.tscn") 

@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var top_fridge = $TopFridge        # Packs here
@onready var bottom_fridge = $BottomFridge  # Attacks here
@onready var PLS_WORK = $PackOpeningScene
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll
@onready var next_stage_button = $MarginContainer/ActionMenu/NextStage

var reroll_cost: int = 2

# --- UPGRADE POOL ---
# will we still have the kurger buns upgrade system?
var upgrade_pool = [
	{"display_name": "Lettuce","id": "lettuce", "type": "upgrade", "effect": "+30 hp", "icon": preload("res://Art/lectuce.png")},
	{"display_name": "beef patty","id": "beef_patty", "type": "upgrade", "effect": "damage up by 10%", "icon": preload("res://Art/burgerpatty.png")},
	{"display_name": "cheese","id": "cheese", "type": "upgrade", "effect": "stamina regeneration by 4", "icon": preload("res://Art/cheese.png")},
	{"display_name": "Bacon","id": "bacon", "type": "joker", "effect": "HP rengeneration by 5", "icon": preload("res://Art/bacon.png")},
	{"display_name": "pickle","id": "pickle", "type": "relic", "effect": "damage multiplier 5%, +15HP", "icon": preload("res://Art/pickle.png")},
	{"display_name": "Fried Chicken","id": "chicken", "type": "relic", "effect": "Increase stamina by 10, Increase stamina rengeneration by 3", "icon": preload("res://Art/fried_chicken.png")},
	{"display_name": "Four Leaf Clover","id": "clover", "type": "relic", "effect": "Increase luck by 10 and money gained", "icon": preload("res://Art/clover.png")},
	{"display_name": "fish","id": "fish", "type": "relic", "effect": "Increase Aoe damage by 12.5%", "icon": preload("res://Art/fish.png")},
	{"display_name": "Nuts","id": "nuts", "type": "relic", "effect": "Increase single damage by 12.5%", "icon": preload("res://Art/peanut.png")}
]

func available_cards() -> Array[CardData]:
	var cards:Array[CardData] = []
	for card in CardData.CARDS:
		# if condition
		cards.append(card)
	return cards

func _ready() -> void:
	AudioManager.play("LevelSelect")
	# Safe check to make sure upgrades array exists on PlayerStats Autoload
	if not "upgrades" in PlayerStats:
		PlayerStats.set("upgrades", [])

	update_gold_ui()
	
	next_stage_button.pressed.connect(_on_next_stage_pressed)
	reroll_button.pressed.connect(_on_reroll_pressed)
	
	if PLS_WORK:
		PLS_WORK.visible = false
		if not PLS_WORK.item_chosen.is_connected(_on_pack_reward_claimed):
			PLS_WORK.item_chosen.connect(_on_pack_reward_claimed)
	
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
	HoverTooltip.hide_tooltip()
	for child in top_fridge.get_children():
		child.queue_free()
	for child in bottom_fridge.get_children():
		child.queue_free()

func generate_entire_shop() -> void:
	#var temp_pack_pool = pack_pool.duplicate()
	var temp_cards_pool:Array[CardData] = available_cards()

	#for i in range(2):
	#	if temp_pack_pool.is_empty(): break
	#	var pack_data = temp_pack_pool.pick_random()
	#	create_card_on_shelf(pack_data, top_fridge, true) 
		
	for i in range(5):
		if temp_cards_pool.is_empty(): break
		var card:CardData = temp_cards_pool.pick_random()
		print("here")
		create_card_on_shelf(card, bottom_fridge)

func create_card_on_shelf(card_data:CardData, target_fridge:Node) -> void:
	var card_node:ShopCard = ShopCard.create(card_data, self)
		
	target_fridge.add_child(card_node)

	# Hover tooltip -- Balatro-style popup instead of the native OS tooltip.
	card_node.mouse_entered.connect(func():
		HoverTooltip.show_at(card_node, card_data.name, card_data.description)
	)
	card_node.mouse_exited.connect(func(): HoverTooltip.hide_tooltip(card_node))

func purchase_card(card:ShopCard) -> void:
	var data:CardData = card.card.data
	if PlayerStats.player_gold < data.price:
		print("Not enough money to buy ", data.name)
		return

	PlayerStats.player_gold -= data.price
	update_gold_ui()
	
	# 1. Force tooltip away immediately
	HoverTooltip.hide_tooltip(card)
	
	# TODO: remove this? this shouldnt be needed
	# 2. Disable mouse input on the bought card so it stops sending mouse_entered
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	card.queue_free()
	
	# TODO: rework player attacks to use new card system
	#PlayerStats.attacks.append(data)
	print("Successfully Bought! Global Inventory Contents: ", PlayerStats.attacks)

func _on_item_purchased(item_data: Dictionary, card_node: Node) -> void:
	var cost = item_data["price"]
	
	if PlayerStats.player_gold >= cost:
		PlayerStats.player_gold -= cost
		update_gold_ui()
		
		# 1. Force tooltip away immediately
		HoverTooltip.hide_tooltip()
		
		# 2. Disable mouse input on the bought card so it stops sending mouse_entered
		if card_node is Control:
			card_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
		card_node.queue_free()
		
		if item_data.get("type") == "pack":
			print("Pack purchased! Opening reward selection...")
			open_pack_screen()
		else:
			PlayerStats.attacks.append(item_data)
			print("Successfully Bought! Global Inventory Contents: ", PlayerStats.attacks)
	else:
		print("Not enough money to buy ", item_data.get("name", "Item"))

func open_pack_screen() -> void:
	if not PLS_WORK:
		print("Error: PackOpeningScene node (PLS_WORK) is missing!")
		return

	# Force tooltip clear one more time to be safe
	HoverTooltip.hide_tooltip()
		
	# Hide the shop shelves right away so the underlying shop cards can't be hovered
	top_fridge.visible = false
	bottom_fridge.visible = false
	reroll_button.disabled = true
	next_stage_button.disabled = true
	
	PLS_WORK.open_pack(upgrade_pool)

func _on_pack_reward_claimed(chosen_data: Dictionary) -> void:
	var current_upgrades = PlayerStats.get("upgrades")
	current_upgrades.append(chosen_data)
	print("Selected pack upgrade: ", chosen_data["display_name"])
	print("Global upgrades Contents: ", current_upgrades)
	
	top_fridge.visible = true
	bottom_fridge.visible = true
	next_stage_button.disabled = false
	update_gold_ui()

func _on_reroll_pressed() -> void:
	if PlayerStats.player_gold >= reroll_cost:
		PlayerStats.player_gold -= reroll_cost
		update_gold_ui()
		
		clear_shop_shelves()
		await get_tree().process_frame 
		generate_entire_shop()

func _on_next_stage_pressed() -> void:
	print("Transitioning to encounter with items: ", PlayerStats.attacks)
	TransitionManager.play_transition("res://scenes/level_select.tscn")
