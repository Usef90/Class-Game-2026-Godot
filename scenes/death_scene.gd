extends Node2D


func _ready() -> void:
	AudioManager.play("death")


func _on_texture_button_button_down() -> void: Globals.end_run()

func _on_replay_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
