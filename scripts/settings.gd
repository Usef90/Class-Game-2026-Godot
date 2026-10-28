extends Node

const START_LEVEL:Vector2i = Vector2i(-1,-1)

var MusicVolume: float = -5
## x: layer, y: node index in layer
var level:Vector2i = START_LEVEL

var failure_counter = 0

var map:LevelSelectMap

var achievements = {
	"john": false,
	"vegan": false,
	"meat_eater": false,
	"pickle": false,
	"nothing_burger": false,
	"lagtrain": false,
	"nuked": false,
	"tutorial_completed": false,
	"pears": false,
	"socrates": false,
	"Ivan": false,
	"Italian": false,
	"ConeL": false,
	"Rack": false,
	"Choi": false,
	"kallum_wang": false,
	"me67": false,
	"mango": false,
	"nuts": false,
	"fih": false,
	"oil_up": false,
}

func _ready() -> void:
	CardData.initialise()

func end_run() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

