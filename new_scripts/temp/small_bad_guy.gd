extends Button

@export var final_boss: bool

@export var next_level_paths: Array[NodePath] = []

@export var next_level:Array = []
@export var layer:int


func _ready() -> void:
	if final_boss:
		owner = get_parent()
	
	_load_connections()
	queue_redraw()

func _load_connections() -> void:
	next_level.clear()
	for path in next_level_paths:
		var target = get_node_or_null(path)
		if not target and get_parent():
			target = get_parent().get_node_or_null(path)
			
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
	if self.name not in Globals.level_current_next_levels:
		return
	var next_level_names = []
	for node in next_level:
		next_level_names.append(node.name)
			
	Globals.level_current_next_levels = next_level_names
	get_tree().change_scene_to_file("res://scenes/final.tscn")
