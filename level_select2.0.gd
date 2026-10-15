extends Control

const battle_button_instances = preload("res://new_scripts/temp/small_bad_guy.tscn")
var ending_node: Button 

var all_button = []

@export var layers: int = 5
@export var layer_spreadness = 100
@export var individual_node_dis = 100
@export var max_num_button_per_node: int = 5

func _ready() -> void:
	print("getting started")
	ending_node = $"map/big bad guy"
	await _generate_thing()
	_draw_lines()
	
	
	
func _draw_lines() -> void:
	for node in $map.get_children():
		node._connecting()
	
	
func _generate_thing():
	var current_depth = 0
	var current_width = 0
	
	for i in range(1, layers + 1):
		var current_layer_buttons = []
		var num_node_this_layer = randi_range(1, max_num_button_per_node)
		var current_empty_space = randi_range(0, 3)
		var num_of_buttons = num_node_this_layer
		var num_of_spaces = current_empty_space
		current_depth += layer_spreadness
		current_width = (num_node_this_layer + current_empty_space) * layer_spreadness
		
		for j in range(num_node_this_layer + current_empty_space):
			if num_of_buttons == 0: 
				break
				
			var spawn_button = false
			if num_of_spaces != 0:
				if randi_range(0, 1) == 0:
					spawn_button = true
					num_of_buttons -= 1
				else:
					num_of_spaces -= 1
			else:
				spawn_button = true
				num_of_buttons -= 1
				
			if spawn_button:
				var button = battle_button_instances.instantiate()
				button.position = Vector2(j * 100 + (ending_node.position.x - (current_width / 2)), current_depth + 67)
				current_layer_buttons.append(button)
				button.layer = layers + 1 - i
				
				if all_button.is_empty():
					button.next_level.append(ending_node)
				else:
					var previous_buttons = all_button[i - 2]
					
					
					var available_targets = previous_buttons.duplicate()
					
					var max_connections = randi_range(1, 3)
					for lines in range(max_connections):
						if available_targets.is_empty():
							break
						var closest = find_closest_node_by_x(button, available_targets)
						if closest:
							button.next_level.append(closest)
							available_targets.erase(closest) 

				$map.add_child(button, true)
				
		all_button.append(current_layer_buttons)


func find_closest_node_by_x(current_node, list_of_nodes):
	var closest_distance: float = INF
	var best: Button = null
	for node in list_of_nodes:
		var current_distance = node.position.distance_squared_to(current_node.position)
		if current_distance < closest_distance:
			closest_distance = current_distance
			best = node
			
	return best
	
