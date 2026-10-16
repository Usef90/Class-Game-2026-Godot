extends Button

@export var final_boss: bool

@export var next_level_paths: Array[NodePath] = []

var next_level:Array = []
@export var layer:int


func _ready() -> void:
	if final_boss:
		owner = get_parent()
	
	_load_connections()
	
	print(next_level_paths)
	print(name)
	queue_redraw()

func _load_connections() -> void:
	next_level.clear()
	for path in next_level_paths:
		var target = get_node_or_null(path)
		if target:
			next_level.append(target)

func _connecting():
	_load_connections()
	queue_redraw()
	
func _draw() -> void:
	for i in next_level:
		
		var targeted_position = i.position + (i.size / 2) + Vector2(0,(i.size / 2).y)

		var line_start = (size / 2) - Vector2(0,(i.size / 2).y)
		var line_end = targeted_position - position
		
		draw_line(line_start, line_end, Color.BLACK, 5, true)

func _on_button_down() -> void:
	if Globals.level != layer:
		return
	get_tree().change_scene_to_file("res://scenes/final.tscn")
