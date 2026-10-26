class_name RelicData
extends RefCounted

static var RELICS:Array[RelicData] = []

## displayed name of the relic
var name: String
## displayed description of the relic
var description: String
## price in shop of the relic
var price: int = 150

static var KNUCKLEBUSTERS:RelicData = new("Knucklebusters", "Start combat with 1 strength")
static var SPARE_BATTERY:RelicData = new("Spare Battery", "For every 12 attacks played, gain 12 health")
static var URANIUM_CORE:RelicData = new("Uranium Core", "After 35 cumulative damage taken, inflict 3 vulnerability, 3 weak, 20 burn to all enemies. Resets at end of combat")
static var SOLAR_PANEL:RelicData = new("Solar Panel", "For every 10 non-attacks played, gain 1 energy")
static var ROBOTIC_CORPSE:RelicData = new("Robotic Corpse", "Gain 300 scrap metal and 1 random curse")
static var BRACES:RelicData = new("Braces", "Start combat with 1 brace")

func _init(_name: String, _description:String) -> void:
	name = _name
	description = _description
	RELICS.append(self)

