class_name CardNode
extends Control

var data:CardData

@onready var name_label:Label = $"name"
@onready var description:Label = $"description"
@onready var image:TextureRect = $"image"
@onready var background:TextureRect = $"background"
@onready var cost:TextureRect = $"cost"

static func create(_data:CardData) -> CardNode:
	var card:CardNode = preload("res://new_scenes/card.tscn").instantiate()
	card.data = _data
	return card

func _ready() -> void:
	name_label.text = data.name
	description.text = data.description
	image.texture = data.image
	match data.energy_cost:
		0: cost.texture = preload("res://Art/IconsNEW/Number0.png")
		1: cost.texture = preload("res://Art/IconsNEW/Number1.png")
		2: cost.texture = preload("res://Art/IconsNEW/Number2.png")
		3: cost.texture = preload("res://Art/IconsNEW/Number3.png")

