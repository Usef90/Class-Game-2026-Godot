extends Node

var MusicVolume: float = -5
var level: Array = []

var failure_counter = 0

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

#removes the current run we have
func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE:
		DirAccess.remove_absolute("res://new_scripts/temp/run.tscn")
func _ready() -> void:
	CardData.initialise()

