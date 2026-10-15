extends Button

@export var final_boss: bool

var next_level:Array = []
var layer = 0

func _ready() -> void:
	print(next_level)
	print(name)
	queue_redraw()

func _connecting():
	queue_redraw()
	
func _draw() -> void:
	for i in next_level:
		var target_center = i.global_position + (i.size / 2) + Vector2(0,(i.size / 2).y)
		var cornball_position = target_center - global_position
		draw_line(Vector2(30,0), cornball_position,Color.BLACK,5, true)
	

func _on_button_down() -> void:
	if Globals.level != layer:
		return
	get_tree().change_scene_to_file("res://scenes/final.tscn")
