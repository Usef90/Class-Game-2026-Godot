extends Node

var MusicVolume: float = -5
var level_current_next_levels: Array = []

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

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if ResourceLoader.exists("res://new_scripts/temp/run.tscn"):
			DirAccess.remove_absolute("res://new_scripts/temp/run.tscn")
