class_name LevelSelectNode
extends Control

var type:LevelSelect.NodeType
var index:Vector2i
var next_levels:Array[LevelSelectNode] = []

func _ready() -> void:
	queue_redraw()
	$"button".text = LevelSelect.NodeType.keys()[type]

func make_selectable() -> void:
	$"button".disabled = false

func _draw() -> void:
	var line_start:Vector2 = Vector2(size.x/2, 10)
	for level in next_levels:
		var line_end:Vector2 = level.position-position+Vector2(level.size.x/2, level.size.y-10)
		draw_line(line_start, line_end, Color.BLACK, 5, true)

func _on_button_down() -> void:
	Globals.level = index
	get_tree().change_scene_to_file("res://scenes/final.tscn")

