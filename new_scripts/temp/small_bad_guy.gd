extends Button

@export var final_boss: bool

var next_level:Array = []
var layer = 0




func _on_button_down() -> void:
	print(layer)
	get_tree().change_scene_to_file("res://scenes/final.tscn")
