extends Control

const battle_button_instances = preload("res://new_scripts/temp/small_bad_guy.tscn")
var ending_node: Button 

@export var layers: int = 5
@export var layer_spreadness = 100
@export var individual_node_dis = 100
@export var max_num_button_per_node: int = 5

func _ready() -> void:
	ending_node = $"big bad guy"
	_generate_thing()
	
func _generate_thing():
	var current_depth = 0
	var current_width = 0
	for i in range(1,layers+1):
		var num_node_this_layer = randi_range(1,max_num_button_per_node)
		var current_empty_space = randi_range(0,3)
		var num_of_buttons = num_node_this_layer
		var num_of_spaces = current_empty_space
		current_depth += layer_spreadness
		current_width = (num_node_this_layer +current_empty_space)* layer_spreadness
		for j in range(num_node_this_layer +current_empty_space):
			if num_of_spaces != 0:
				if randi_range(0,1) == 0:
					var button = battle_button_instances.instantiate()
					button.position = Vector2(j*100 + (ending_node.position.x- (current_width/2)),current_depth+67)
					add_child(button)
					num_of_buttons -=1
				else:
					num_of_spaces -=1
			elif num_of_spaces == 0:
				var button = battle_button_instances.instantiate()
				button.position = Vector2(j*100 + (ending_node.position.x- (current_width/2)),current_depth+67)
				add_child(button)
				num_of_buttons -=1
			elif num_of_buttons == 0:
				break
			
		
