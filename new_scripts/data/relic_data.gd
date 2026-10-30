class_name RelicData
extends RefCounted

static var RELICS:Array[RelicData] = []

## displayed name of the relic
var name: String
## displayed description of the relic
var description: String
## price in shop of the relic
var price: int = 150

var image:Texture2D

static var KNUCKLEBUSTERS:RelicData = new("Knucklebusters", "Start combat with 1 strength") \
			.with_image(preload("res://New Art Folder/Knucklebusters.png"))
static var SPARE_BATTERY:RelicData = new("Spare Battery", "For every 12 attacks played, gain 12 health") \
			.with_image(preload("res://New Art Folder/Batter e.png"))
static var URANIUM_CORE:RelicData = new("Uranium Core", "After 35 cumulative damage taken, inflict 3 vulnerability, 3 weak, 20 burn to all enemies. Resets at end of combat") \
			.with_image(preload("res://New Art Folder/Uranium Core Thing.png"))
static var SOLAR_PANEL:RelicData = new("Solar Panel", "For every 10 non-attacks played, gain 1 energy") \
			.with_image(preload("res://New Art Folder/Solir panel.png"))
static var BRACES:RelicData = new("Braces", "Start combat with 1 brace") \
			.with_image(preload("res://New Art Folder/braces.png"))

func _init(_name: String, _description:String) -> void:
	name = _name
	description = _description
	RELICS.append(self)

func with_image(_image:Texture2D) -> RelicData:
	image = _image
	return self

