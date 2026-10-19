extends Button

@export var final_boss: bool

@export var next_level: Array = []
var converted_next_levels: Array = []



func _ready() -> void:
	if final_boss:
		owner = get_parent()
	

	_convert()
	print(next_level)
	print(name)
	queue_redraw()

func _convert():
	for i in next_level:
		converted_next_levels.append(get_parent().find_child(i))

func _connecting():
	queue_redraw()
	
func _draw() -> void:
	
	for i in converted_next_levels:
		
		var targeted_position = i.position + (i.size / 2) + Vector2(0,(i.size / 2).y)

		var line_start = (size / 2) - Vector2(0,(i.size / 2).y)
		var line_end = targeted_position - position
		
		draw_line(line_start, line_end, Color.BLACK, 5, true)

func _on_button_down() -> void:
	print(Globals.level)
	if name not in Globals.level:
		return
	Globals.level = next_level
	get_tree().change_scene_to_file("res://scenes/final.tscn")
